// More info about initialization & config:
// - https://revealjs.com/initialization/
// - https://revealjs.com/config/
Reveal.initialize({
  loop: true,
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
  dependencies: [
    { src: 'plugin/mermaid/mermaid.js' }
  ],
  // Learn about plugins: https://revealjs.com/plugins/
  plugins: [RevealMarkdown, RevealHighlight, RevealNotes, ],
  // Chart Config
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
    const heading = document.createElement("div");
    heading.innerText = val.id;
    heading.className = "agenda_heading left-grid-item";
    if (["", "deck", "agenda"].indexOf(heading.innerText) == -1) {
      const entry = document.createElement("li");
      entry.className = "fragment grid-container";
      const page_number = document.createElement("a");
      page_number.className = "page_num right-grid-item";
      page_number.innerText = ' ' + ((k) => {
        if (k > 9) { return k }
        return '0' + k
      })(key);
      page_number.href = window.location.href.replace('deck', key);
      entry.append(heading, page_number);
      if (heading.innerText != "Agenda") {
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
