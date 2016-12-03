import os
import re
import json

def handle(buffer, language, url):
    data = []
    expression  = "Queen raster \((?P<n1>\d*)x(?P<n2>\d*)\)"
    expression += "\n...took (?P<duration>\d*\.\d*) seconds."
    expression += "\n...(?P<solutions>\d*) solutions found."
    for match in re.finditer(expression, buffer):
        data.append({
            'language': language,
            'url': url,
            'chessboard-width': int(match.group("n1")),
            'duration': float(match.group('duration')),
            'solutions': int(match.group('solutions'))
        })
    assert len(data) > 0
    return data

def handle_bas(buffer):
    print("analyse FreeBASIC log ...")
    return handle(buffer, 'FreeBASIC', 'http://www.freebasic.net')

def handle_pas(buffer):
    print("analyse FreePascall log ...")
    return handle(buffer, 'free pascal', 'http://www.freepascal.org')

def handle_node_js(buffer):
    print("analyse Node.js log ...")
    return handle(buffer, 'Node.js', 'https://nodejs.org/en')

def handle_go(buffer):
    print("analyse Go log ...")
    return handle(buffer, 'Go', 'https://golang.org')

def handle_python(buffer):
    print("analyse Python log ...")
    return handle(buffer, 'Python', 'https://www.python.org')

def handle_cplusplus(buffer):
    print("analyse C++ log ...")
    return handle(buffer, 'C++', 'https://gcc.gnu.org')

def handle_c(buffer):
    print("analyse C log ...")
    return handle(buffer, 'C', 'https://gcc.gnu.org')

def handle_php(buffer):
    print("analyse PHP log ...")
    return handle(buffer, 'PHP', 'https://secure.php.net/')

def handle_ruby(buffer):
    print("analyse Ruby log ...")
    return handle(buffer, 'Ruby', 'https://www.ruby-lang.org/en/')

def handle_d(buffer):
    print("analyse D log ...")
    return handle(buffer, 'D', 'https://dlang.org/')

def handle_scala(buffer):
    print("analyse Scala log ...")
    return handle(buffer, 'Scala', 'https://www.scala-lang.org/')

def handle_perl(buffer):
    print("analyse Perl log ...")
    return handle(buffer, 'Perl', 'https://www.perl.org/')

def handle_java(buffer):
    print("analyse Java log ...")
    return handle(buffer, 'Java', 'https://www.java.com/en/')

def handle_groovy(buffer):
    print("analyse Groovy log ...")
    return handle(buffer, 'Groovy', 'http://groovy-lang.org/')

def handle_mono(buffer):
    print("analyse Mono(CSharp) log ...")
    return handle(buffer, 'Mono(CSharp)', 'http://www.mono-project.com/')

def handle_clisp(buffer):
    print("analyse clisp(Steel Bank) log ...")
    return handle(buffer, 'clisp(Steel Bank)', 'http://www.sbcl.org/')

def main():
    data = []
    for entry in os.listdir("reports"):
        if entry.endswith(".log"):
            full = os.path.join(os.getcwd(), "reports", entry)
            buffer = open(full).read()
            if entry.find(".bas.") >= 0:
                data += handle_bas(buffer)
            elif entry.find(".pas.") >= 0:
                data += handle_pas(buffer)
            elif entry.find(".js.") >= 0:
                data += handle_node_js(buffer)
            elif entry.find(".go.") >= 0:
                data += handle_go(buffer)
            elif entry.find(".py.") >= 0:
                data += handle_python(buffer)
            elif entry.find(".cxx.") >= 0:
                data += handle_cplusplus(buffer)
            elif entry.find(".c.") >= 0:
                data += handle_c(buffer)
            elif entry.find(".php.") >= 0:
                data += handle_php(buffer)
            elif entry.find(".rb.") >= 0:
                data += handle_ruby(buffer)
            elif entry.find(".d.") >= 0:
                data += handle_d(buffer)
            elif entry.find(".scala.") >= 0:
                data += handle_scala(buffer)
            elif entry.find(".pl.") >= 0:
                data += handle_perl(buffer)
            elif entry.find(".java.") >= 0:
                data += handle_java(buffer)
            elif entry.find(".groovy.") >= 0:
                data += handle_groovy(buffer)
            elif entry.find(".cs.") >= 0:
                data += handle_mono(buffer)
            elif entry.find(".lisp.") >= 0:
                data += handle_clisp(buffer)

    with open("reports/results.json", "w") as handle:
        handle.write(json.dumps(data))

if __name__ == "__main__":
    main()
