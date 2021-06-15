// More info about initialization & config:
// - https://revealjs.com/initialization/
// - https://revealjs.com/config/
mermaid.initialize({startOnLoad:true});
Reveal.initialize({
  hash: true,
  controlsTutorial: true,
  controlsLayout: "edges",
  progress: true,
  slideNumber: "c/t",
  showSlideNumber: "all",
  history: true,
  touch: true,
  transition: "slide",
  autoAnimate: true,
  // Learn about plugins: https://revealjs.com/plugins/
  plugins: [RevealMarkdown, RevealHighlight, RevealNotes, RevealChart, ],
  // Chart Config
  chart: {
    defaults: {
      global: {
        title: { fontColor: "#000" },
        legend: {
          labels: { fontColor: "#000" },
        },
      },
      scale: {
        scaleLabel: { fontColor: "#000" },
        gridLines: { color: "#000", zeroLineColor: "#000" },
        ticks: { fontColor: "#000" },
      },
    },
    line: {
      borderColor: [
        "rgba(20,220,220,.8)",
        "rgba(220,120,120,.8)",
        "rgba(20,120,220,.8)",
      ],
      borderDash: [
        [5, 10],
        [0, 0],
      ],
    },
    bar: {
      backgroundColor: [
        "rgba(20,220,220,.8)",
        "rgba(220,120,120,.8)",
        "rgba(20,120,220,.8)",
      ],
    },
    pie: {
      backgroundColor: [
        [
          "rgba(0,0,0,.8)",
          "rgba(220,20,20,.8)",
          "rgba(20,220,20,.8)",
          "rgba(220,220,20,.8)",
          "rgba(20,20,220,.8)",
        ],
      ],
    },
    radar: {
      borderColor: [
        "rgba(20,220,220,.8)",
        "rgba(220,120,120,.8)",
        "rgba(20,120,220,.8)",
      ],
    },
  },
}).then(() => {
  // reveal.js is ready
  // Create QR Code dynamically
  new QRCode(document.getElementById("qr-code"), {
    text: "https://github.com/nk-designz/distributed_prometheus", // window.location.href.slice(0, -1),
    width: 300,
    height: 300,
    colorDark: "#ffffff",
    colorLight: "#7d6b7d",
    correctLevel: QRCode.CorrectLevel.H,
  });
  // Create the Agenda from ids tags
  document.getElementsByTagName("section").forEach((val, key) => {
    const heading = val.id;
    if (["", "deck", "agenda"].indexOf(heading) == -1) {
      const entry = document.createElement("li");
      const page_number = document.createElement("a");
      page_number.className = "page_num";
      page_number.innerText = ((k) => {
        if (k > 9) { return k }
        return '0' + k
      })(key) + ' ';
      page_number.href = window.location.href.replace('deck', key);
      entry.append(page_number, heading);

      if (heading != "Agenda") {
        document.getElementById("agenda-index").append(entry);
      }
    }
  });
});
const player = document.getElementById("player")
player.currentTime = 200;
Reveal.on("slidechanged", (event) => {
  // event.previousSlide, event.currentSlide, event.indexh, event.indexv
  if (event.currentSlide.id == "Installation") {
    player.play();
  }
});
