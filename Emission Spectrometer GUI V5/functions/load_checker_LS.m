function load_state = load_checker_LS()
    MSG = 'You must delete previous data to continue loading, are you sure?';
    load_state = questdlg(MSG,'Yes','No');
end