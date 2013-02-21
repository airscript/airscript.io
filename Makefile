
setup:
	python setup.py develop
	heroku git:remote -a airscript-ui

run:
	python -m airscript.ui

deploy_pull:
	git pull heroku master

deploy:
	git push heroku master
