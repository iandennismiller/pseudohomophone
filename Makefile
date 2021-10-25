all:
	@echo ok

run:
	./mccann.py

requirements:
	pip3 install -r requirements.txt

.PHONY: all run requirements
