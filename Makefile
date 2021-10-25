all:
	@echo ok

run:
	./src/mccann.py

requirements:
	pip3 install -r ./src/requirements.txt

.PHONY: all run requirements
