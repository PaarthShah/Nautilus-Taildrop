"""Pytest configuration.

``test_taildrop.py`` imports the GTK4 sender module, which needs PyGObject and the
GTK/Adw/Pango typelibs. PyGObject ships in the dev dependency group, so it is
normally importable under ``uv run pytest``; if it is somehow unavailable we skip
collecting the module rather than erroring. (Widget *construction* additionally
needs a display — that finer-grained skip lives in the test itself.)
"""


def _gi_stack_available() -> bool:
    try:
        import gi  # noqa: PLC0415  (lazy: conftest must load even without PyGObject)

        gi.require_version("Gtk", "4.0")
        gi.require_version("Adw", "1")
        gi.require_version("Pango", "1.0")
        from gi.repository import Gtk  # noqa: F401, PLC0415
    except (ImportError, ValueError):
        return False
    return True


collect_ignore = []
if not _gi_stack_available():
    collect_ignore.append("test_taildrop.py")
