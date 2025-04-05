let timer;
let isFocus = true;
let currentSubject = '';
const quotes = [
  "Stay focused, stay sharp!",
  "Every Pomodoro counts!",
  "Discipline beats motivation.",
  "Consistency is key!",
  "Focus now, win later!",
  "Push through. You're stronger than distractions.",
  "Big goals need deep focus.",
  "You vs. You. Win today!"
];

function startFocus() {
  const examMode = document.getElementById("examMode").checked;
  isFocus = true;
  currentSubject = document.getElementById("subject").value;
  startTimer(examMode ? 25 : 25);
  document.getElementById("status").innerText = "Focus Time Started 🧠";
}

function startBreak() {
  const examMode = document.getElementById("examMode").checked;
  isFocus = false;
  startTimer(examMode ? 5 : 5);
  document.getElementById("status").innerText = "Break Time 🧃";
}

function resetTimer() {
  clearInterval(timer);
  document.getElementById("minutes").innerText = "25";
  document.getElementById("seconds").innerText = "00";
  document.getElementById("status").innerText = "Timer Reset";
}

function startTimer(minutes) {
  clearInterval(timer);
  let time = minutes * 60;
  updateDisplay(time);

  timer = setInterval(() => {
    time--;
    updateDisplay(time);

    if (time <= 0) {
      clearInterval(timer);
      const message = isFocus ? "Focus session done! 🎉" : "Break over! Time to work!";
      document.getElementById("status").innerText = message;
      showQuote();
      if (isFocus) {
        savePomodoro();
        updateStats();
      }
    }
  }, 1000);
}

function updateDisplay(time) {
  const mins = Math.floor(time / 60);
  const secs = time % 60;
  document.getElementById("minutes").innerText = String(mins).padStart(2, '0');
  document.getElementById("seconds").innerText = String(secs).padStart(2, '0');
}

function showQuote() {
  const quote = quotes[Math.floor(Math.random() * quotes.length)];
  document.getElementById("quote").innerText = "${quote}";
}

function savePomodoro() {
  const today = new Date().toISOString().slice(0, 10);
  const data = JSON.parse(localStorage.getItem("pomodoroData") || "{}");

  if (!data[today]) {
    data[today] = { total: 0, subjects: {} };
  }

  data[today].total += 1;

  if (!data[today].subjects[currentSubject]) {
    data[today].subjects[currentSubject] = 0;
  }

  data[today].subjects[currentSubject] += 1;

  localStorage.setItem("pomodoroData", JSON.stringify(data));
}

function updateStats() {
  const data = JSON.parse(localStorage.getItem("pomodoroData") || "{}");
  const today = new Date().toISOString().slice(0, 10);
  const oneWeekAgo = new Date();
  oneWeekAgo.setDate(oneWeekAgo.getDate() - 6);

  let totalWeek = 0;
  let subjectCounts = {};

  for (const [date, value] of Object.entries(data)) {
    if (new Date(date) >= oneWeekAgo) {
      totalWeek += value.total;
      for (const subject in value.subjects) {
        if (!subjectCounts[subject]) subjectCounts[subject] = 0;
        subjectCounts[subject] += value.subjects[subject];
      }
    }
  }

  const topSubject = Object.keys(subjectCounts).sort((a, b) => subjectCounts[b] - subjectCounts[a])[0] || "None";

  const stats = `
    📅 Today: ${data[today]?.total || 0} Pomodoros<br>
    📈 This Week: ${totalWeek} Pomodoros<br>
    🔍 Most Studied Subject: ${topSubject}
  `;

  document.getElementById("status").innerHTML = stats;
}

// Show stats on load
window.onload = updateStats;
