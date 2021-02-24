from pathlib import Path

from handler import handler

@handler.command(prefix="h")
def header_handler(text, context):
    return "#" * int(text) + " "

@handler.command(prefix="env:")
def env_handler(text, context):
    result = (
        f"\\begin{{{text}}}\n"
        f"<keepindent>    <cursor>\n"
        f"<keepindent>\\end{{{text}}}"
    )
    return result

@handler.command(prefix="\[\[", cut_prefix=False)
def embed_handler(text, context):
    if not text.endswith("]]"):
        return

    vault_path = Path(context['vault_path'])
    this_note_inner_path = context['inner_path']
    this_note_name = context['file_name']
    if this_note_name.endswith(".md"):
        this_note_name = this_note_name[:-3]

    text = text[2:-2]
    that_inner_path, _, that_name = text.partition("|")
    if not that_name:
        that_name = that_inner_path.rpartition("/")[-1]

    this_note_path = this_note_name
    if this_note_inner_path != "/":
        this_note_path = this_note_inner_path + "/" + this_note_path

    that_file_path = (vault_path / f"{that_inner_path}.md")
    print(that_file_path, that_file_path.exists(), file=sys.stderr)
    if not that_file_path.exists():
        return

    return f"[[{this_note_inner_path}|{this_note_name}]] : [[{that_inner_path}|{that_name}]]"

@handler.command(prefix="cite:")
def cite_handler(text, context):
    if text.startswith("url:"):
        pass
