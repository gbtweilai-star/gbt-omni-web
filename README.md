# omni_web

**One capability bit from GBT V8, packaged standalone.** No. 301 of 341,
`tentacle` domain (Tentacle).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 万能触手·Web六态：看结构/读源码/读讲解/改文件/交给AI/跑项目；git+github+stackblitz一键触达

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-omni-web.git
cd gbt-omni-web
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_omni_web info                  # capability card
python -m gbt_omni_web spec --json           # machine-readable contract
python -m gbt_omni_web check --payload '{"op": "path"}'
python -m gbt_omni_web run   --payload '{"op": "path"}'
```

Real `info` output from this machine:

```text
omni_web  (tentacle)  v1.0.0
----------------------------------------
万能触手·Web六态：看结构/读源码/读讲解/改文件/交给AI/跑项目；git+github+stackblitz一键触达

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : op
             op=看结构|读源码|读讲解|改文件|gitingest|跑项目；repo=GitHub URL或本地路径；files=[…]（read_source）；path/content/mode（edit_file，mode=write|append|replace）；max_files/max_chars（gitingest）
values     : path, content, mode
```

Wire a real implementation:

```python
from gbt_omni_web import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({"op": "path"}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| `op` | yes | declared required by the registry |

Registry hint (`params_hint`): op=看结构|读源码|读讲解|改文件|gitingest|跑项目；repo=GitHub URL或本地路径；files=[…]（read_source）；path/content/mode（edit_file，mode=write|append|replace）；max_files/max_chars（gitingest）

**注册表登记的取值 / 子动作（3 个）**：`path`、`content`、`mode`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
23 passed in 0.13s
```

## Provenance

| field | value |
|---|---|
| capability | `omni_web` |
| domain | `tentacle` |
| handler | `omni_web` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [tentacle/omni_web](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/tentacle/omni_web.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
