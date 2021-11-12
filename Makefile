all:
	@echo ok

run-activations-mccann:
	docker exec lens sudo -u lens /bin/bash -c '\
		cd /home/lens/Work/pseudohomophone && \
		PMSP_RANDOM_SEED=1 \
		PMSP_DILUTION=0 \
		PMSP_PARTITION=0 \
		./bin/alens-batch.sh \
			./src/produce-activations-mccann.tcl'

run-activations-pmsp:
	docker exec lens sudo -u lens /bin/bash -c '\
		cd /home/lens/Work/pseudohomophone && \
		PMSP_RANDOM_SEED=1 \
		PMSP_DILUTION=0 \
		PMSP_PARTITION=0 \
		./bin/alens-batch.sh \
			./src/produce-activations-pmsp.tcl'

generate-examples:
	./src/mccann.py

requirements:
	pip3 install -r ./src/requirements.txt

start-lens:
	docker run -d --rm \
		--name lens \
		-p 5901:5901 \
		-v $(PWD):/home/lens/Work/pseudohomophone \
		iandennismiller/lens

stop-lens:
	docker container stop lens

.PHONY: all run requirements lens
