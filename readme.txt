Steps for Windows:

1. Prerequisites
	LM-Studio for local AI backend
	Git for Windows to run bash scripts

2. Setup
	Run "Git Bash" from start menu
		cd <to-this-unzipped-folder>
	Run to download LM-Studio 
		./only-the-very-first-run.sh
	Run LM-Studio server

3. Run the matcher
	Download selected AI model
		./download-model.sh
	Check in LM-studio if the model needs to be inserted (loaded)
	Specify two resume PDFs and one txt job description (check that it works w/o Internet too):
		./which-is-better-matching-profile.sh <path-to-PDF1> <path-to-PDF2> <path to description.txt>

Potential TO DO:
	Use this as comparator for bubble-sorting profiles to get the best match for better results.
	Implement script for Yes/No/Maybe requests to check each requirement from requirements list in job description to improve requirements check of profile before matching

Implementation notes:
	Binary results allow avoiding reading AI output which may have inconsistencies at the moment of implementation, which is not recommended for human perception.
	Test if backend works

FIXME:
	pdftotext doesn't allways produce full PDF contents

Troubleshooting:

	If something doesn't work, you can test backend with ./hi.sh scrtipt:

	$ ./hi.sh what is your name, tell a joke!
	############################################################################################################################################################################################## 100.0%
		"content": "My name is **Gemma 4**. I am a large language model developed by Google DeepMind.\n\nAnd since you asked for a joke... here it goes!\n\nWhy did the scarecrow win an award?\nBecause he was outstanding in his field! 😂"

	If PDF content converted to txt generates some special symbols, addin line like  gsub(/\x0C/, "")  may be required.