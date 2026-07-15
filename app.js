const stars = document.querySelector("#stars");
const time = document.querySelector("#local-time");

const fragment = document.createDocumentFragment();
for (let i = 0; i < 44; i += 1) {
  const star = document.createElement("i");
  star.className = "star";
  star.style.left = `${Math.random() * 100}%`;
  star.style.top = `${Math.random() * 100}%`;
  star.style.setProperty("--speed", `${3 + Math.random() * 5}s`);
  star.style.setProperty("--delay", `${Math.random() * -8}s`);
  fragment.appendChild(star);
}
stars.appendChild(fragment);

function updateClock() {
  time.textContent = new Intl.DateTimeFormat(undefined, {
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
  }).format(new Date());
}

updateClock();
setInterval(updateClock, 30_000);

document.querySelectorAll(".app-card").forEach((card) => {
  card.addEventListener("pointermove", (event) => {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
    const rect = card.getBoundingClientRect();
    const x = (event.clientX - rect.left) / rect.width - 0.5;
    const y = (event.clientY - rect.top) / rect.height - 0.5;
    card.style.transform = `translateY(-7px) perspective(800px) rotateX(${-y * 2.5}deg) rotateY(${x * 2.5}deg)`;
  });

  card.addEventListener("pointerleave", () => {
    card.style.removeProperty("transform");
  });
});
