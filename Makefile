
.PHONY: all

all: copy

.PHONY: copy

LINA_DICTO_ASSETS_DIR=app/src/main/assets/lina_dicto

copy:
	# get lina_dicto project
	rm -rf $(LINA_DICTO_ASSETS_DIR)
	mkdir -p $(LINA_DICTO_ASSETS_DIR)
	cp -r ../lina_dicto/lina_dicto/* $(LINA_DICTO_ASSETS_DIR)/
	# electron固有コードの無力化
	echo "'use strict';" > $(LINA_DICTO_ASSETS_DIR)/js/menu.js
	echo "'use strict';" > $(LINA_DICTO_ASSETS_DIR)/js/file_loader.js
	# ファイル読み込みの展開と削除
	bash ./tool/loader.sh "$(LINA_DICTO_ASSETS_DIR)/js/dictionary_loader.js"
	bash ./tool/loader.sh "$(LINA_DICTO_ASSETS_DIR)/js/language.js"
	rm -rf $(LINA_DICTO_ASSETS_DIR)/data/
	# android固有コードの上書き
	cp -r ./lina_dicto/overwrite/* $(LINA_DICTO_ASSETS_DIR)/
	# remove electron settings
	#rm -rf $(LINA_DICTO_ASSETS_DIR)/node_modules/
	rm -rf $(LINA_DICTO_ASSETS_DIR)/*.js
	rm -rf $(LINA_DICTO_ASSETS_DIR)/*.json
	# ** 不要ファイルを除去
	rm -rf $(LINA_DICTO_ASSETS_DIR)/.git
	rm -rf $(LINA_DICTO_ASSETS_DIR)/setup
	rm -rf $(LINA_DICTO_ASSETS_DIR)/release
	rm -rf $(LINA_DICTO_ASSETS_DIR)/work
	rm -rf $(LINA_DICTO_ASSETS_DIR)/test
	# ** browserify
	cd $(LINA_DICTO_ASSETS_DIR)/ && mv js/index.js .
	cd $(LINA_DICTO_ASSETS_DIR)/ && node ./node_modules/browserify/bin/cmd.js index.js -o bundle.js
	cd $(LINA_DICTO_ASSETS_DIR)/ && sed -i 's:src="./js/index.js">:src="./bundle.js">:' index.html
	# ** ここ大変だから手動で書き換えて
	#sed -i 's@dicPath:.*\\$$@dicPath: "node_modules/kuromoji/dict"@' $(LINA_DICTO_ASSETS_DIR)/bundle.js
	# ** kuromoji 辞書ファイル以外のnode_modules以下ファイルを除去
	cp -r $(LINA_DICTO_ASSETS_DIR)/node_modules/kuromoji/dict .
	rm -rf $(LINA_DICTO_ASSETS_DIR)/node_modules/
	mkdir -p $(LINA_DICTO_ASSETS_DIR)/node_modules/kuromoji
	mv dict/ $(LINA_DICTO_ASSETS_DIR)/node_modules/kuromoji
	# ** kuromoji 辞書ファイルをリネーム Androidのassetから.gzが取り除かれる問題を回避
	sed -i 's/\.dat\.gz/.dat.bin/g' $(LINA_DICTO_ASSETS_DIR)/bundle.js
	cd $(LINA_DICTO_ASSETS_DIR)/node_modules/kuromoji/dict/ && rename 's/\.gz/.bin/' *

clean:
	rm -rf $(LINA_DICTO_ASSETS_DIR)

