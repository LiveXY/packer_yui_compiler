#!/bin/sh

currPath=$(pwd)

rootPath=$(dirname $0)
compiler="$rootPath/compiler.jar"
packer="$rootPath/packer.exe"
compiler="$rootPath/compiler.jar"
yuicompressor="$rootPath/yuicompressor-2.4.2.jar"

for f in "$@"
do
	fs0=`ls -l $f | awk '{print $5}'`

	if [ "${f##*.}" == "js" ]; then
		new=${f/%.js/-min.js}
		java -jar "$compiler" --js "$f" --js_output_file "$new"
		if [ $? -eq 0 ]; then
			fs1=`ls -l $new | awk '{print $5}'`
			echo "-> compiler 混搅压缩成功！原文件大小：$fs0 混搅压缩后文件大小：$fs1"
			(mono "$packer" "$new") > /dev/null 2>&1
			if [ $? -eq 0 ]; then
				fs2=`ls -l $new | awk '{print $5}'`
				echo "-> packer 压缩加密成功！原文件大小：$fs0 压缩加密后文件大小：$fs2"
				if [ $fs2 -gt $fs1 ]; then
					java -jar "$compiler" --js "$f" --js_output_file "$new"
					if [ $? -eq 0 ]; then
						echo "-> compiler 混搅压缩成功！原文件大小：$fs0 混搅压缩后文件大小：$fs1"
					else
						echo "-> compiler 混搅压缩失败！"
					fi
				fi
			else
				echo "-> packer 压缩加密失败！"
			fi
		else
			echo "-> compiler 混搅压缩失败！"
		fi
	fi

	if [ "${f##*.}" == "css" ]; then
		new=${f/%.css/-min.css}
		java -jar "$yuicompressor" --charset UTF-8 "$f" -o "${f/%.css/-min.css}"
		if [ $? -eq 0 ]; then
			fs1=`ls -l $new | awk '{print $5}'`
			echo "-> yuicompressor 压缩成功！原文件大小：$fs0 混搅压缩后文件大小：$fs1"
		else
			echo "-> yuicompressor 压缩失败！"
		fi
	fi
done
