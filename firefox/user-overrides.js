// make performance faster
// https://linuxreviews.org/HOWTO_Make_Mozilla_Firefox_Blazing_Fast_On_Linux
user_pref("gfx.x11-egl.force-enabled", true);

// stuff that makes the url bar easier to use
user_pref("keyword.enabled", true);
user_pref("browser.urlbar.oneOffSearches", true);
user_pref("browser.search.suggest.enabled", true);
user_pref("browser.formfill.enable", true);
user_pref("browser.urlbar.suggest.searches", true);
user_pref("browser.urlbar.suggest.history", true);
user_pref("browser.urlbar.suggest.bookmark", true);
user_pref("browser.urlbar.suggest.openpage", true);
user_pref("browser.urlbar.autoFill", true);

// generally useful stuff
// make sure the startup page is the home page
user_pref("browser.startup.page", 1);
user_pref("browser.startup.homepage", "about:home");
user_pref("browser.newtabpage.enabled", true);
user_pref("browser.newtab.preload", true);

// resistFingerprinting changes
// change the default window size so it's not always a square
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.window.maxInnerWidth", 1500);
user_pref("privacy.window.maxInnerHeight", 900);

// extra security
user_pref("browser.download.forbid_open_with", true);
user_pref("signon.rememberSignons", false); // we use our own password manager

// the reader view text-to-speech caused crackling noises
// https://old.reddit.com/r/linuxmint/comments/i19h4k/firefox_causing_crackling_noise_on_reader_mode_is/
// https://old.reddit.com/r/linuxquestions/comments/gu2kew/sound_crackle_and_pulseaudio_crashes_when_firefox/fsfunz3
user_pref("media.webspeech.synth.enabled", false);

// really smooth scrolling
user_pref("general.smoothScroll", true);
user_pref("general.smoothScroll.currentVelocityWeighting", 0);
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 750);
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 1000);
user_pref("general.smoothScroll.mouseWheel.migrationPercent", 0);
user_pref("general.smoothScroll.stopDecelerationWeighting", 0.82);
user_pref("mousewheel.min_line_scroll_amount", 25);

// enable customisation via style sheets
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// customisations for cascade
user_pref("layers.acceleration.force-enabled", true);
user_pref("gfx.webrender.all", true);
user_pref("svg.context-properties.content.enabled", true);
