import pynvim
import pathlib
import re


@pynvim.plugin
class Zpp(object):
    def __init__(self, vim):
        self.nvim: pynvim.Nvim = vim

    @pynvim.command("CreateCppSource", eval='expand("%")', sync=True)
    def create_cpp_source(
        self,
        filename: str,
    ):
        if not filename.endswith((".h", ".hpp", ".hxx")):
            self.nvim.err_write(f"Not a c/c++ header file: {filename}")
            return
        headerpath = pathlib.Path(filename)
        cpppath = headerpath.with_suffix(".cpp")
        m = re.match(r"(.*)/[iI]nclude/(.*)", filename)
        line = f'#include "{headerpath.name}"'
        if m:
            src_dir = pathlib.Path(m.group(1)) / "Src"
            if src_dir.exists():
                cpppath = src_dir / f"{headerpath.stem}.cpp"
                line = f"#include <{m.group(2)}>"

        with open(cpppath, "w") as f:
            f.write(line)

        self.nvim.command(f"edit {str(cpppath)}")

    def get_cpp_source_file(self, filename: str):
        if not filename.endswith((".h", ".hpp", ".hxx")):
            return
        headerpath = pathlib.Path(filename)
        cpppath = headerpath.with_suffix(".cpp")
        self.nvim.out_write(f"{headerpath=}\n")
        m = re.match(r"(.*)/[iI]+nclude/(.*)", filename)
        self.nvim.out_write(f"{m=}\n")
        if m:
            src_dir = pathlib.Path(m.group(1)) / "Src"
            if src_dir.exists():
                cpppath = src_dir / f"{headerpath.stem}.cpp"
        return str(cpppath)

    @pynvim.command("CreateImplementation", range="", sync=True)
    def create_implementation(self, range, **kwargs):
        self.nvim.out_write(f"{range=}, {kwargs=}\n")
        # string = self.get_selected_text()
        lines = self.nvim.current.buffer[range[0] - 1 : range[1]]
        string = " ".join(lines)
        string = string.replace("virtual", "")
        string = string.replace("override", "")
        string = string.replace("final", "")
        self.nvim.out_write(f"{string=}\n")
        m = re.match(
            r"(?:\w+EXPORT)?(?:virtual)?(.*&?)(\s+|&)(\w+)\((.*)\)(.*);",
            string,
            re.DOTALL,
        )
        class_name = self.get_class_name("\n".join(self.nvim.current.buffer[:]))
        if m:
            func_sig = f"{m.group(1)}{m.group(2)} {class_name}{m.group(3)}({m.group(4)}){m.group(5)} {{}}"
            self.nvim.funcs.setreg("", func_sig)
            cpp_file = self.get_cpp_source_file(self.nvim.current.buffer.name)
            if cpp_file:
                self.nvim.command(f"edit {cpp_file}")
                self.nvim.current.buffer.append(func_sig)
            self.nvim.out_write(f"{func_sig=}\n")
        else:
            self.nvim.err_write(f"cannot match function: {string=}\n")

    def get_selected_text(self):
        nvim = self.nvim
        mode = nvim.eval("mode()")
        self.nvim.out_write(f"{mode=}\n")
        if mode in ("v", "V"):  # visual or visual-line/block
            start_pos = nvim.funcs.getpos("'<")
            end_pos = nvim.funcs.getpos("'>")
            start_line, start_col = start_pos[1] - 1, start_pos[2] - 1
            end_line, end_col = end_pos[1] - 1, end_pos[2]
            lines = nvim.current.buffer[start_line : end_line + 1]
            if start_line == end_line:
                selected_text = lines[0][start_col:end_col]
            else:
                selected_text = "\n".join(
                    [lines[0][start_col:]] + lines[1:-1] + [lines[-1][:end_col]]
                )
            return selected_text
        else:
            return nvim.current.line

    def get_class_name(self, string: str):
        self.nvim.out_write(f"fulltext: {string}\n")
        m = re.match(
            r".*(?:class|struct)\s+(?:\w+EXPORT\s+)?(\w+)\s+.*};", string, re.DOTALL
        )
        return m.group(1) + "::" if m else ""
