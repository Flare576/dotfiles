# Finalize WSL

During setup a new folder should have been created at C:\flarescript_temp, and three files should have been downloaded:

- Inconsolata.otf
- Inconsolata_bold.ttf
- wsltty-3.1.4.2-install-x86_64.exe (version may differ)

FROM WINDOWS, navigate to this folder and install the two fonts, then install WSLTTY. This program is a terminal for WSL based on Mintty.

Once installed, you should see a new "Ubuntu Terminal %" entry in your start menu: Open it.

After it loads, click the logo in the top-left, and choose `Options`. Click *Text*, then the **Select** button next to the current font. In the following dialog, choose:

- Font: Inconsolata for Powerline
- Font Style: Medium
- Size: 14

Click "OK", and you should be off to the races!
