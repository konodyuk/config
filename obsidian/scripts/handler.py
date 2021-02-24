import re
import sys
import json

class Processor:
    def __init__(self, regex, function, text_preprocessor=None):
        self.regex = re.compile(regex)
        self.function = function
        self.preprocessor = text_preprocessor

    def test(self, text):
        return bool(self.regex.match(text))

    def process(self, text, context):
        if self.preprocessor is not None:
            text = self.preprocessor(text)
        return self.function(text, context)

class Handler:
    def __init__(self):
        self.processors = []

    @staticmethod
    def read_request():
        request = json.loads(input())
        return request

    @staticmethod
    def send_response(replacement):
        response = {"id": 0, "replacement": str(replacement)}
        print(json.dumps(response))

    def run(self):
        while True:
            try:
                request = self.read_request()
                replacement = self.find_replacement(request["text"], request["context"])
                if replacement is None:
                    continue
                self.send_response(replacement)
            except EOFError:
                return
            except Exception as e:
                print(e, file=sys.stderr)

    def find_replacement(self, text, context):
        for processor in self.processors:
            if processor.test(text):
                return processor.process(text, context)
        return None

    def regex(self, regex, text_preprocessor=None):
        def wrapper(function):
            processor = Processor(regex, function, text_preprocessor)
            self.processors.append(processor)
            return function
        return wrapper

    def command(self, string=None, prefix=None, cut_prefix=True):
        if string is not None:
            return self.regex(f"^{string}$")
        if prefix is not None:
            text_preprocessor = None
            if cut_prefix:
                text_preprocessor = lambda x: x[len(prefix):]
            return self.regex(f"^{prefix}", text_preprocessor=text_preprocessor)

handler = Handler()
