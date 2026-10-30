import reflex as rx

from nooklane.i18n import TEXTS


class LangState(rx.State):
    """The page language (English / 繁體中文), remembered in the browser."""

    lang: str = rx.LocalStorage("en", name="nooklane_lang_v2")

    @rx.var
    def ui_lang(self) -> str:
        return self.lang if self.lang in TEXTS else "en"

    @rx.var
    def t(self) -> dict[str, str]:
        return {**TEXTS["en"], **TEXTS.get(self.ui_lang, {})}

    @rx.event
    def init_lang(self):
        """First visit: default to English."""
        if not self.lang or self.lang not in TEXTS:
            self.lang = "en"

    @rx.event
    def toggle_lang(self):
        self.lang = "zh" if self.ui_lang == "en" else "en"
