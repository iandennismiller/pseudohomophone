all:
	@echo ok

run-activations:
	docker exec lens sudo -u lens /bin/bash -c '\
		cd /home/lens/Work/pseudohomophone && \
		PMSP_RANDOM_SEED=1 \
		PMSP_DILUTION=0 \
		PMSP_PARTITION=0 \
		./bin/alens-batch.sh \
			./src/produce-activations.tcl'

generate-examples:
	./src/mccann.py

requirements:
	pip3 install -r ./src/requirements.txt

lens:
	docker run -d --rm \
		--name lens \
		-p 5901:5901 \
		-v $(PWD):/home/lens/Work/pseudohomophone \
		iandennismiller/lens

.PHONY: all run requirements lens
