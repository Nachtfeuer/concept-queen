""" Log files analyzer for queen algorihm performance. """
import os
import re
import json


def handle(text_buffer, language, distribution, url):
    """ parse log files for queen algorithm performance details. """
    data = []

    print("language={0}, distribution={1}, url={2}"
          .format(language, distribution, url))

    source = ""
    for match in re.finditer("SOURCE=(?P<source>.*)", text_buffer):
        source = match.group('source')
        break

    version = ""
    for match in re.finditer("VERSION=(?P<version>.*)", text_buffer):
        version = match.group('version')
        break

    expression = r"Queen raster \((?P<n1>\d*)x(?P<n2>\d*)\)"
    expression += r"\n...took (?P<duration>\d*\.\d*) seconds."
    expression += r"\n...(?P<solutions>\d*) solutions found."

    for match in re.finditer(expression, text_buffer):
        data.append({
            'language': language,
            'url': url,
            'distribution': distribution,
            'chessboard-width': int(match.group("n1")),
            'duration': float(match.group('duration')),
            'solutions': int(match.group('solutions')),
            'source': source,
            'version': version
        })
    assert len(data) > 0
    return data


def handle_descriptor(text_buffer, descriptor):
    """ parsing test buffer for details. """
    return handle(text_buffer,
                  descriptor['language'],
                  descriptor['distribution'],
                  descriptor['url'])


def main():
    """ application entry point. """
    options = json.loads(open("analyse.json").read())
    descriptors = options['descriptors']

    data = []
    for entry in os.listdir("reports"):
        if entry.endswith(".log"):
            full = os.path.join(os.getcwd(), "reports", entry)
            text_buffer = open(full).read()

            for descriptor in descriptors:
                if entry.find(descriptor['key']) >= 0:
                    data += handle_descriptor(text_buffer, descriptor)
                    break

    with open("reports/results.json", "w") as handle:
        handle.write(json.dumps(data))

if __name__ == "__main__":
    main()
