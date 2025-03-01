library(pagedown)
chrome_print("D:/Curriculum-Vitae-Latex/pagedown/template-zh.html", 
             "D:/Curriculum-Vitae-Latex/pagedown/template-zh.pdf")

chrome_print("D:/Curriculum-Vitae-Latex/pagedown/cv.html", 
             "D:/Curriculum-Vitae-Latex/pagedown/cv.pdf")

system("G:/Study/wkhtmltox/bin/wkhtmltopdf.exe F:/DataScience/CVdaishaoqing/Curriculum-Vitae-Latex/cn/template-zh.html 
       F:/DataScience/CVdaishaoqing/Curriculum-Vitae-Latex/cn/template-zh.pdf")

system("G:/Study/wkhtmltox/bin/wkhtmltopdf.exe http://gisersqdai.top/mycv/
       F:/DataScience/CVdaishaoqing/Curriculum-Vitae-Latex/cn/encv.pdf")
