cpan-deps: cpanfile
	@cpanm --installdeps --notest .

run: bin/build-test-reporter
	@$< -v

load: sql/load.sql $(wildcard data/*.log)
	@psql -f $<

debian-deps:
	@sudo apt-get update
	@sudo apt-get install -y cpanminus libnet-ssleay-perl
	sudo $(MAKE) cpan-deps
