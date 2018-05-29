SPEC=riscv-trace-spec

INCLUDES_TEX = introduction.tex

all:	$(SPEC).pdf

$(SPEC).pdf: $(SPEC).tex $(INCLUDES_TEX) 
	pdflatex -shell-escape $< && makeindex $(SPEC) && pdflatex -shell-escape $<

publish:	$(SPEC).pdf
	cp $< $(SPEC)-`git rev-parse --abbrev-ref HEAD`.`git rev-parse --short HEAD`.pdf

vc.tex: .git/logs/HEAD
	# https://thorehusfeldt.net/2011/05/13/including-git-revision-identifiers-in-latex/
	echo "%%% This file is generated by Makefile." > vc.tex
	echo "%%% Do not edit this file!\n%%%" >> vc.tex
	git log -1 --format="format:\
	    \\gdef\\GITHash{%H}\
	    \\gdef\\GITAbrHash{%h}\
	    \\gdef\\GITAuthorDate{%ad}\
	    \\gdef\\GITAuthorName{%an}" >> vc.tex

changelog.tex: .git/logs/HEAD Makefile
	echo "%%% This file is generated by Makefile." > changelog.tex
	echo "%%% Do not edit this file!\n%%%" >> changelog.tex
	git log --no-merges --date=short --pretty="format:vhEntry{%h}{%ad}{%an}{%s}" | \
	    sed -e "s,\\\\,{\\\\textbackslash},g" -e "s,[_#^],\\\\&,g" -e s/^/\\\\/ >> changelog.tex

clean:
	rm -f $(SPEC).pdf *.aux $(SPEC).toc $(SPEC).log $(SPEC).aux $(SPEC).idx $(SPEC).ilg $(SPEC).ind $(SPEC).lof $(SPEC).log $(SPEC).lot $(SPEC).out $(SPEC).pdf $(SPEC).toc
	    
