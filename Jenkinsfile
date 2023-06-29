pipeline {
	agent any

	parameters {
		string(name: 'PR_BRANCHES', defaultValue: '', description: 'Comma separated list of additional pull request branches (e.g. meta-trustx=PR-177,meta-trustx-rpi=PR-2,gyroidos_build=PR-97)')
	}

	stages {
		stage('build GyroidOS') {
			steps {
				script {
					REPO_NAME = determineRepoName()

					if (CHANGE_TARGET != null) {
						// in case this is a PR build
						// set the BASE_BRANCH to the target
						// e.g. PR-123 -> kirkstone
						BASE_BRANCH = env.CHANGE_TARGET
					} else {
						// in case this is a regular build
						// let the BASE_BRANCH equal this branch
						// e.g. kirkstone -> kirkstone
						BASE_BRANCH = env.BRANCH_NAME
					}
				}

				build job: "../gyroidos/${BASE_BRANCH}", wait: true, parameters: [
					string(name: "PR_BRANCHES", value: "${REPO_NAME}=${env.BRANCH_NAME},${env.PR_BRANCHES}"),
					string(name: "GYROID_ARCH", value: "arm64"),
					string(name: "GYROID_MACHINE", value: "raspberrypi3-64"),
					string(name: "BUILD_INSTALLER", value: "n")
				]

				build job: "../gyroidos/${BASE_BRANCH}", wait: true, parameters: [
					string(name: "PR_BRANCHES", value: "${REPO_NAME}=${env.BRANCH_NAME},${env.PR_BRANCHES}"),
					string(name: "GYROID_ARCH", value: "arm32"),
					string(name: "GYROID_MACHINE", value: "raspberrypi2"),
					string(name: "BUILD_INSTALLER", value: "n")
				]
			}
		}
	}
}

// Determine the Repository name from its URL.
// Avoids hardcoding the name in every Jenkinsfile individually.
// Source: https://stackoverflow.com/a/45690925
String determineRepoName() {
	return scm.getUserRemoteConfigs()[0].getUrl().tokenize('/').last().split("\\.")[0]
}
