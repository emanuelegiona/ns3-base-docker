# MIT License

# Copyright (c) 2024 Emanuele Giona <giona.emanuele@gmail.com> (SENSES Lab, 
# Sapienza University of Rome)

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

CWD := $(CURDIR)

.ONESHELL:

help:
	@echo "Usage: make target [arguments]"
	@echo "Targets:"
	@echo " - help\n\tShows this help message."
	@echo " --- Builds profiles ---"
	@echo " - show_profile\n\tShows the ns-3 build profile currently in use."
	@echo " --- Simulation driver programs ---"
	@echo " - compile FILE=<filename>\n\tCopies the given driver program, then uses ./waf to compile it against ns-3."
	@echo " - build_run FILE=<filename> [ARGS=<CLI args>] [LOG=<path/to/log>]\n\tBuilds and executes the given driver program."
	@echo " - run FILE=<filename> [ARGS=<CLI args>] [LOG=<path/to/log>]\n\tExecutes the given driver program (no building first)."
	@echo " - clean FILE=<filename>\n\tDeletes the given driver program."
	@echo " --- Modules ---"
	@echo " - new_module FILE=<filename>\n\tUses a ns-3 utility to create a new module under 'contrib/' with the given name, also copying it locally."
	@echo " - sync_module FILE=<filename>\n\tReplaces contents of the module under 'contrib/' with local contents."
	@echo " - rm_module FILE=<filename>\n\tRemoves the module with the given name (placed under 'contrib/')."
	@echo " --- Debug ---"
	@echo " - valgrind FILE=<filename> LOG=<path/to/log/file>\n\tRuns the driver program through the Valgrind memory checking tool, writing the log to a file."
	@echo " - gdb FILE=<filename>\n\tRuns the driver program through the GNU debugger."
	@echo " - test SUITE=<test suite name> [LOG=<path/to/file>]\n\tRuns the ns-3 testing tool selecting the given test suite."
	@echo " - gdb_test SUITE=<test suite name>\n\tRuns the ns-3 testing tool selecting the given test suite, through the GNU debugger."

show_profile:
	@. $(NS3_PY_ENV)/bin/activate
	@cd $(NS3_CURR_PROFILE)
	@./waf --check-profile
	@deactivate

compile:
ifeq ($(FILE),)
	$(error 'compile' target requires a FILE variable with the ns-3 driver program name)
endif
	@echo " Compiling..."
	@cp -f $(FILE) $(NS3_CURR_PROFILE)/scratch/
	@. $(NS3_PY_ENV)/bin/activate
	@cd $(NS3_CURR_PROFILE)
	@./waf
	@deactivate
	@echo " Done."

build_run:
ifeq ($(FILE),)
	$(error 'build_run' target requires a FILE variable with the ns-3 driver program name)
endif
	@echo " $(shell date): running..."
	@. $(NS3_PY_ENV)/bin/activate
	@cd $(NS3_CURR_PROFILE)
ifeq ($(LOG),)
	@./waf --run scratch/$(FILE) --command-template="%s $(ARGS)"
else
	@./waf --run scratch/$(FILE) --command-template="%s $(ARGS)" >> $(LOG) 2>&1
endif
	@deactivate
	@echo " $(shell date): done."

run:
ifeq ($(FILE),)
	$(error 'run' target requires a FILE variable with the ns-3 driver program name)
endif
	@echo " $(shell date): running..."
	@. $(NS3_PY_ENV)/bin/activate
	@cd $(NS3_CURR_PROFILE)
ifeq ($(LOG),)
	@./waf --run-no-build scratch/$(FILE) --command-template="%s $(ARGS)"
else
	@./waf --run-no-build scratch/$(FILE) --command-template="%s $(ARGS)" >> $(LOG) 2>&1
endif
	@deactivate
	@echo " $(shell date): done."

clean:
ifeq ($(FILE),)
	$(error 'clean' target requires a FILE variable with the ns-3 driver program name)
endif
	@echo " Cleaning..."
	@cd $(NS3_CURR_PROFILE)
	@rm scratch/$(FILE)
	@echo " Done."

new_module:
ifeq ($(FILE),)
	$(error 'new_module' target requires a FILE variable with the new module's name)
endif
	@echo " Creating new module $(NS3_CURR_PROFILE)/contrib/$(FILE)..."
	@. $(NS3_PY_ENV)/bin/activate
	@cd $(NS3_CURR_PROFILE)
	@./utils/create-module.py contrib/$(FILE)
	@cd $(CWD)
	@cp -rf $(NS3_CURR_PROFILE)/contrib/$(FILE) $(FILE)/
	@deactivate
	@echo " Done."

rm_module:
ifeq ($(FILE),)
	$(error 'rm_module' target requires a FILE variable with the module's name)
endif
	@echo " Removing module contrib/$(FILE)..."
	@rm -rf $(NS3_CURR_PROFILE)/contrib/$(FILE)
	@echo " Done."

sync_module:
ifeq ($(FILE),)
	$(error 'sync_module' target requires a FILE variable with the module's name)
endif
	@echo " Syncronizing module..."
	@make rm_module FILE=$(FILE)
	@cp -rf $(FILE)/ $(NS3_CURR_PROFILE)/contrib/
	@echo " Done."

valgrind:
ifeq ($(FILE),)
	$(error 'valgrind' target requires a FILE variable with the ns-3 driver program name)
endif
ifeq ($(LOG),)
	$(error 'valgrind' target requires a LOG variable with the path to the log file)
endif
	@echo " Running..."
	@. $(NS3_PY_ENV)/bin/activate
	@cd $(NS3_CURR_PROFILE)
	@./waf --run scratch/$(FILE) --command-template="valgrind --leak-check=full --show-leak-kinds=all --log-file=$(LOG) %s"
	@deactivate
	@echo " Done."

gdb:
ifeq ($(FILE),)
	$(error 'gdb' target requires a FILE variable with the ns-3 driver program name)
endif
	@echo " Running..."
	@. $(NS3_PY_ENV)/bin/activate
	@cd $(NS3_CURR_PROFILE)
	@./waf --run scratch/$(FILE) --command-template="gdb %s"
	@deactivate
	@echo " Done."

test:
ifeq ($(SUITE),)
	$(error 'test' target requires a SUITE variable with the ns-3 test suite name)
endif
	@echo " Testing..."
	@. $(NS3_PY_ENV)/bin/activate
	@cd $(NS3_CURR_PROFILE)
ifeq ($(LOG),)
	@./test.py -n -s $(SUITE)
else
	@./test.py -n -s $(SUITE) --text=$(LOG)
endif
	@deactivate
	@echo " Done."

gdb_test:
	@. $(NS3_PY_ENV)/bin/activate
	@cd $(NS3_CURR_PROFILE)
	@./waf --run test-runner --command-template="gdb %s"
	@deactivate

.PHONY: clean
