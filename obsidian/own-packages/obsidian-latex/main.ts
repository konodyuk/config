import {  Notice, Plugin } from 'obsidian';
import { readFileSync } from 'fs';

const preamble = `
\\newenvironment{substitution}[0]{\\qty[\\begin{aligned}}{\\end{aligned}]}
\\newenvironment{solution}[0]{\\begin{aligned}}{\\end{aligned}}
`;

export default class JaxPlugin extends Plugin {
	onload() {
    console.log("[MathJax Plugin]", "loading")

    Object.defineProperty(window, 'MathJax', {
      set(o) {
        o.loader = { load: ['[tex]/physics', '[tex]/ams'] };
        o.tex.packages = { '[+]': ['physics', 'ams']};
        o.tex.macros = {
          R: "\\mathbb{R}",
          RR: ["\\R^{#1}", 1],
          Ri: ["\\RR{#1}", 1],
          Rii: ["\\RR{#1 \\times #2}", 2],
          Riii: ["\\RR{#1 \\times #2 \\times #3}", 3],
          Riiii: ["\\RR{#1 \\times #2 \\times #3 \\times #4}", 4],
          Riiiii: ["\\RR{#1 \\times #2 \\times #3 \\times #4 \\times #5}", 5],
          Rn: "\\Ri{n}",
          Rm: "\\Ri{m}",
          Rnm: "\\Rii{n}{m}",
          Rmn: "\\Rii{m}{n}",
          ub: "\\underbrace",
          ob: "\\overbrace"
        };

        o.startup.ready = () => {
          MathJax.startup.defaultReady();

          console.log("[MathJax Plugin]", "running preamble:", preamble);

          MathJax.tex2chtml(preamble);
        }

        delete window.MathJax;
        window.MathJax = o;
      },
      configurable: true,
    });
	}

	onunload() {
		console.log("[MathJax Plugin]", "unloading");
	}
}

