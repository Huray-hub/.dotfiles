#!/bin/bash

ensure-lf() {
	if [ -f /usr/bin/lf ]; then
		echo "lf is installed"
	else
		echo "installing lf"
		sudo pacman -S lf
	fi
}

ensure-lfrun() {
	if [ -f /usr/bin/lfrun ]; then
		echo "lfrun is installed"
	else
		echo "installing lfrun"
		git clone https://github.com/cirala/lfimg &&
			cd lfimg &&
			make install &&
			cp cleaner preview to ~/.config/lf/ &&
			cd .. &&
			rm -r lfrun
	fi
}

install-lfrun-dependencies() {
	local deps_pacman=(
		"ueberzug"
		"ffmpegthumbnailer"
		"imagemagick"
		"poppler"
		"wkhtmltopdf"
		"bat"
		# "chafa"
		"unzip"
		# "7z"
		"unrar"
		"catdoc"
		"docx2txt"
		"odt2txt"
		"gnumeric"
		# "cdrtools"
		# "perl-image-exiftool"
	)

	# printf "Dependencies (comment out those you don't want):
	#    ueberzug             cli utl to preview images on X11
	#    ffmpegthumbnailer   videos
	#    imagemagick         .jpeg .png .bmp .svg .tiff .gif
	#    poppler             .pdf
	#    wkhtmltopdf         .html
	#    bat                 text files
	#    chafa               image preview over SSH or inside Wayland session
	#    unzip               .zip .jar
	#    7z                  .7z
	#    unrar               .rar
	#    catdoc              .doc
	#    docx2txt            .docx
	#    odt2txt             .odt *.ods
	#    gnumeric            .xls .xlsx
	#    cdrtools            info for .iso files (uses only iso-info command)
	#    perl-image-exiftool     music files (exiftool command)\n"

	# pacman -S "${deps_pacman[@]}"

	local deps_aur=(
		"epub-thumbnailer-git"
		# "transmission"   # not worth it except you want the torrent client as well
		# "mcomix"
	)

	# printf "AUR dependencies (comment out those you don't want):
	#    epub-thumbnailer-git    .epub
	#    transmission            .torrent
	#    mcomix                  .cbz .cbr\n"

	yay -S "${deps_pacman[@]}" "${deps_aur[@]}"
}

install-lf() {
	ensure-lf
	ensure-lfrun
	install-lfrun-dependencies
}

install-lf

unset -f install-lf
unset -f ensure-lf
unset -f ensure-lfrun
unset -f install-lfrun-dependencies
