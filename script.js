let workingDir = [];
let stagingArea = [];
let localRepo = [];
let remoteRepo = [];
let stashedRepo = [];
let counterAdd = 1;
let counterCommit = 1;
let counterPush = 1;
let counterStash = 1;
let counterImOutOfNames = 1;
let currentUserId = null;

async function register(username, password) {
	try {
		const response = await fetch('/register', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded',
			},
			body: `username=${username}&password=${password}`
		});

		const text = await response.text();
		if (response.ok) {
			updateDisplay("Registration successful");
			return true;
		} else {
			updateDisplay(text);
			return false;
		}
	} catch (error) {
		console.error('Error:', error);
		updateDisplay("Registration failed");
		return false;
	}
}

async function login(username, password) {
	try {
		const response = await fetch('/login', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded',
			},
			body: `username=${username}&password=${password}`
		});

		const text = await response.text();
		if (text === "Login successful") {
			const userId = await getUserId(username);
			currentUserId = userId;

			localStorage.setItem('currentUserId', currentUserId);

			updateDisplay("Login successful");
			document.getElementById('auth-container').style.display = 'none';
			document.getElementById('main-container').style.display = 'block';
			workingDir.push("abc");
			renderRepos();
			return true;
		} else {
			updateDisplay(text);
			return false;
		}
	} catch (error) {
		console.error('Error:', error);
		updateDisplay("Login failed");
		return false;
	}
}

window.addEventListener('load', () => {
	const storedUserId = localStorage.getItem('currentUserId');
	if (storedUserId) {
		currentUserId = parseInt(storedUserId);
		document.getElementById('auth-container').style.display = 'none';
		document.getElementById('main-container').style.display = 'block';
		loadState();
		renderRepos();
	}
});

async function logout() {
	if (!currentUserId) {
		updateDisplay("No user is currently logged in");
		return;
	}

	try {
		const response = await fetch('/logout', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded',
			},
			body: `id=${currentUserId}`
		});

		const text = await response.text();
		if (response.ok) {
			updateDisplay("Logged out successfully");
		} else {
			updateDisplay("Logout failed: " + text);
		}
	} catch (error) {
		console.error('Error logging out:', error);
		updateDisplay("Logout failed");
	}

	currentUserId = null;
	localStorage.removeItem('currentUserId');
	document.getElementById('auth-container').style.display = 'block';
	document.getElementById('main-container').style.display = 'none';
	workingDir = [];
	stagingArea = [];
	localRepo = [];
	remoteRepo = [];
	stashedRepo = [];
	renderRepos();
}

async function getUserId(username) {
	try {
		const response = await fetch(`/getUserId?name=${username}`);
		if (!response.ok) throw new Error('Failed to get user ID');
		const data = await response.text();
		return parseInt(data);
	} catch (error) {
		console.error('Error getting user ID:', error);
		return null;
	}
}

async function saveState() {
	if (!currentUserId) {
		updateDisplay("Please login first");
		return;
	}

	const state = {
		workingDir,
		stagingArea,
		localRepo,
		remoteRepo,
		stashedRepo,
		counterAdd,
		counterCommit,
		counterPush,
		counterStash,
		counterImOutOfNames
	};

	try {
		const response = await fetch('/save', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded',
			},
			body: `id=${currentUserId}&data=${JSON.stringify(state)}`
		});

		if (!response.ok) throw new Error('Failed to save state');
		updateDisplay("State saved");
	} catch (error) {
		console.error('Error saving state:', error);
		updateDisplay("Failed to save state");
	}
}

async function loadState() {
	try {
		const response = await fetch(`/load?id=${currentUserId}`);
		if (!response.ok) throw new Error('Failed to load state');

		const data = await response.text();
		if (data && data !== "No data found") {
			const state = JSON.parse(data);
			workingDir = state.workingDir;
			stagingArea = state.stagingArea;
			localRepo = state.localRepo;
			remoteRepo = state.remoteRepo;
			stashedRepo = state.stashedRepo;
			counterAdd = state.counterAdd;
			counterCommit = state.counterCommit;
			counterPush = state.counterPush;
			counterStash = state.counterStash;
			counterImOutOfNames = state.counterImOutOfNames;
			renderRepos();
			updateDisplay("State loaded");
		}
	} catch (error) {
		console.error('Error loading state:', error);
		updateDisplay("Failed to load state");
	}
}

const styles = document.createElement('style');
styles.textContent = `
	#auth-container { display: block; }
	#main-container { display: none; }
    `;
document.head.appendChild(styles);

async function getCurrentUserId(username) {
	const response = await fetch(`/getUserId?username=${username}`);
	const data = await response.json();
	return data.id;
}

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
	if (!currentUserId) {
		updateDisplay("Please login first");
		return;
	}
	console.log("git add called");
	if (workingDir.length > 0) {
		let code = peek(workingDir);
		counterCommit = counterAdd;
		stagingArea[0] = code;
		updateDisplay("git add: Staged changes for commit.");
		renderRepos();
	}
}

function gitCommit() {
	if (!currentUserId) {
		updateDisplay("Please login first");
		return;
	}
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
	if (!currentUserId) {
		updateDisplay("Please login first");
		return;
	}
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
	if (!currentUserId) {
		updateDisplay("Please login first");
		return;
	}
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
	if (!currentUserId) {
		updateDisplay("Please login first");
		return;
	}
	if (remoteRepo.length === 1) {
		let code = peek(remoteRepo);
		counterPush = counterImOutOfNames;
		localRepo[0] = code;
		updateDisplay("git fetch: Fetched changes from the remote repository.");
		renderRepos();
	}
}

function gitStash() {
	if (!currentUserId) {
		updateDisplay("Please login first");
		return;
	}
	if (localRepo.length === 1) {
		counterStash = counterPush;
		stashedRepo[0] = localRepo.pop();
		updateDisplay("git stash: Stashed changes.");
		renderRepos();
	}
}

function gitStashApply() {
	if (!currentUserId) {
		updateDisplay("Please login first");
		return;
	}
	if (stashedRepo.length === 1) {
		counterPush = counterStash;
		localRepo[0] = stashedRepo.pop();
		updateDisplay("git stash apply: Applied stashed changes.");
		renderRepos();
	}
}

function otherPush() {
	if (!currentUserId) {
		updateDisplay("Please login first");
		return;
	}
	if (remoteRepo.length !== 1) return;
	console.log("other person pushed");
	updateDisplay("other person pushed changes to the remote repository.");
	counterImOutOfNames++;
	remoteRepo[0] = getRandomString(3);
	renderRepos();
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
		if (containerId === "workingDirBlocks") blockElement.textContent = `${block} - Version ${counterAdd}`;
		else if (containerId === "stagingBlocks") blockElement.textContent = `${block} - Version ${counterCommit}`;
		else if (containerId === "localBlocks") blockElement.textContent = `${block} - Version ${counterPush}`;
		else if (containerId === "remoteBlocks") blockElement.textContent = `${block} - Version ${counterImOutOfNames}`;
		else if (containerId === "stashBlocks") blockElement.textContent = `${block} - Version ${counterStash}`;
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

async function handleRegister() {
	const username = document.getElementById('reg-username').value;
	const password = document.getElementById('reg-password').value;

	if (!username || !password) {
		updateDisplay("Please enter both username and password");
		return;
	}

	await register(username, password);
}

async function handleLogin() {
	const username = document.getElementById('login-username').value;
	const password = document.getElementById('login-password').value;

	if (!username || !password) {
		updateDisplay("Please enter both username and password");
		return;
	}

	await login(username, password);
}

async function saveState() {
	if (!currentUserId) {
		updateDisplay("Please login first");
		return;
	}

	const state = {
		workingDir,
		stagingArea,
		localRepo,
		remoteRepo,
		stashedRepo,
		counterAdd,
		counterCommit,
		counterPush,
		counterStash,
		counterImOutOfNames
	};

	try {
		const response = await fetch('/save', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded',
			},
			body: `id=${currentUserId}&data=${JSON.stringify(state)}`
		});

		if (!response.ok) throw new Error('Failed to save state');
		updateDisplay("State saved");
	} catch (error) {
		console.error('Error saving state:', error);
		updateDisplay("Failed to save state");
	}
}

workingDir.push("abc");
renderRepos();