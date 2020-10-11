TAG    = $(shell git rev-parse --short HEAD)
BRANCH = $(shell git branch --show-current)

zip: check
	$(shell [ $(BRANCH) == 'default' ])
	zip -r ../$(notdir $(CURDIR))-$(BRANCH)-$(TAG).zip . -x "*.git*" -x "*terraform*" -x "*~"
	zip -r ../$(notdir $(CURDIR)).zip . -x "*.git*" -x "*terraform*" -x "*~"

clean:
	rm -vf ../$(notdir $(CURDIR))*.zip

check:
	@ if [ "${BRANCH}" != "default" ]; then \
		echo "Zips should only be created from the default branch. BRANCH == $(BRANCH)"; \
		exit 99; \
	fi

.PHONY: zip clean
