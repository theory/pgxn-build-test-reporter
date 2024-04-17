dependencies: cpanfile
	@cpanm --installdeps --notest .

run: bin/build-test-reporter
	@$< -vv
