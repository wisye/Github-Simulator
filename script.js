let workingDir = [];
let stagingArea = [];
let localRepo = [];
let remoteRepo = [];
let stashedRepo = [];
let counterAdd = 1;
let counterCommit = 1;
let counterPush = 1;
let counterImOutOfNames = 1;

function peek(array) {
	if (array.length === 0) return null;
	return array[array.length - 1];
}

function getRandomString(length) {
	const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
	let result = '';
	for (let i = 0; i < length; i++) {
		const randomIndex = Math.floor(Math.random() * characters.length);
		result += characters[randomIndex];
	}
	return result;
}


function gitAdd() {
	console.log("git add called");
	if (workingDir.length === 1) {
		let code = peek(workingDir);
		counterCommit = counterAdd;
		stagingArea[0] = code;
		updateDisplay("git add: Staged changes for commit.");
		renderRepos();
	}
}

function gitCommit() {
	console.log("git commit called");
	if (stagingArea.length === 1) {
		let code = stagingArea.pop();
		counterPush = counterCommit;
		localRepo[0] = code;
		updateDisplay("git commit: Committed changes to the repository.");
		renderRepos();
	}
}

function gitPush() {
	console.log("git push called");
	if (localRepo.length === 1) {
		let code = peek(localRepo);
		counterImOutOfNames = counterPush;
		remoteRepo[0] = code;
		updateDisplay("git push: Pushed changes to the remote repository.");
		renderRepos();
	}
}

function gitPull() {
	if (remoteRepo.length === 1) {
		let code = peek(remoteRepo);
		counterAdd = counterImOutOfNames;
		counterPush = counterImOutOfNames;
		localRepo[0] = code;
		workingDir[0] = code;
		updateDisplay("git pull: Pulled changes from the remote repository.");
		renderRepos();
	}
}

function gitFetch() {
	if (remoteRepo.length === 1) {
		let code = peek(remoteRepo);
		counterPush = counterImOutOfNames;
		localRepo[0] = code;
		updateDisplay("git fetch: Fetched changes from the remote repository.");
		renderRepos();
	}
}

function gitStash() {
	console.log("git stash called");
	if (localRepo.length === 1) {
		stashedRepo.push(localRepo.pop());
		updateDisplay("git stash: Stashed changes.");
		renderRepos();
	}
}

// function gitCheckout() {
// 	console.log("git checkout called");
// 	updateDisplay("git checkout: Checked out to a different branch.");
// 	renderRepos();
// }

function otherPush() {
	if (remoteRepo.length !== 1) return;
	console.log("other person pushed");
	updateDisplay("other person pushed changes to the remote repository.");
	counterImOutOfNames++;
	remoteRepo[0] = getRandomString(3);
	renderRepos();
}

function updateDisplay(message) {
	const displayArea = document.getElementById("displayArea");
	const newMessage = document.createElement("p");
	newMessage.textContent = message;
	displayArea.appendChild(newMessage);
}

function renderRepos() {
	renderBlocks("workingDirBlocks", workingDir);
	renderBlocks("stagingBlocks", stagingArea);
	renderBlocks("localBlocks", localRepo);
	renderBlocks("remoteBlocks", remoteRepo);
	renderBlocks("stashBlocks", stashedRepo);
}

function renderBlocks(containerId, blocks) {
	const container = document.getElementById(containerId);
	container.innerHTML = '';
	blocks.forEach((block, index) => {
		const blockElement = document.createElement("div");
		blockElement.className = "block";
		if (containerId === "workingDirBlocks") blockElement.textContent = `HEAD : ${block} - Version ${counterAdd}`;
		else if (containerId === "stagingBlocks") blockElement.textContent = `HEAD : ${block} - Version ${counterCommit}`;
		else if (containerId === "localBlocks") blockElement.textContent = `HEAD : ${block} - Version ${counterPush}`;
		else if (containerId === "remoteBlocks") blockElement.textContent = `HEAD : ${block} - Version ${counterImOutOfNames}`;
		else if (containerId === "stashBlocks") blockElement.textContent = `HEAD : ${block} - Version ${counterPush}`;
		container.appendChild(blockElement);
	});
}

function usersInput() {
	const input = document.getElementById("users").value;
	if (input && workingDir.length === 1) {
		counterAdd++;
		workingDir[0] = input;
		updateDisplay("User input: Added to working directory.");
		renderRepos();
	}
}

workingDir.push("abc");
renderRepos();