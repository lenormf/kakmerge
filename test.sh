#! /bin/sh

main() {
    dir_test=$(mktemp -d "${TMPDIR:-/tmp}"/kakmerge-test-XXXXXX)

    printf 'Created temporary directory: %s\n' "${dir_test}"

    cd "${dir_test}"

    git init

    git config --local merge.tool kakmerge
    git config --local mergetool.kakmerge.trustExitCode true
    git config --local mergetool.kakmerge.cmd "env LOCAL=\"\${LOCAL}\" BASE=\"\${BASE}\" REMOTE=\"\${REMOTE}\" MERGED=\"\${MERGED}\" kakmerge $*"

    cat >animals.txt <<-EOF
		cat
		dog
		octopus
		octocat

		other weird animals

		octobat
		eof
	EOF

    git add animals.txt
    git commit -m "Initial commit"

    git checkout -b octodog
    sed -i 's/octopus/octodog/; s/octobat/octoocto/' animals.txt

    git commit -am "Replace octopus with octodog"

    git checkout master
    sed -i 's/octopus/octoman/; s/octobat/octo/' animals.txt

    git commit -am "Replace octopus with an octoman"

    git merge octodog

    git mergetool
}

main "$@"
