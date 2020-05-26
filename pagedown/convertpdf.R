library(pagedown)
chrome_print("F:/DataScience/CVdaishaoqing/Curriculum-Vitae-Latex/cn/template-zh.html", 
             "F:/DataScience/CVdaishaoqing/Curriculum-Vitae-Latex/cn/template-zh.pdf")

system("G:/Study/wkhtmltox/bin/wkhtmltopdf.exe F:/DataScience/CVdaishaoqing/Curriculum-Vitae-Latex/cn/template-zh.html 
       F:/DataScience/CVdaishaoqing/Curriculum-Vitae-Latex/cn/template-zh.pdf")

system("G:/Study/wkhtmltox/bin/wkhtmltopdf.exe http://gisersqdai.top/mycv/
       F:/DataScience/CVdaishaoqing/Curriculum-Vitae-Latex/cn/encv.pdf")
