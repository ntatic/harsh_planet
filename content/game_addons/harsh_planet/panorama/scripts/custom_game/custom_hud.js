var UI = {
	RoundInfoContainer: $('#RoundInfoContainer'),
	RoundLevel: $('#RoundLevel'),
	RoundProgress: $('#RoundProgress'),
	RoundTitle: $('#RoundTitle'),
	Heroes: [$('#Hero0'), $('#Hero1'), $('#Hero2'), $('#Hero3')],
	LivesLeft: $('#LivesLeft'),
	CountdownContainer: $('#CountdownContainer'),
	CountdownValue: $('#CountdownValue'),
	NotificationsRoot: $('#NotificationsRoot')
}

// display notification
GameEvents.Subscribe('ce_hud_notification', function(JSON) {
	var notification = $.CreatePanel('Label', UI.NotificationsRoot, '');
	notification.hittest = false;
	notification.html = true;
	notification.text = JSON.Text;
	$.Schedule(!isNaN(parseFloat(JSON.Duration)) && isFinite(JSON.Duration) ? JSON.Duration : 3, function() {
		notification.DeleteAsync(0);
	});	
});

// update round info
GameEvents.Subscribe('ce_hud_update_roundinfo', function(JSON) {
	if (JSON.Round) {
		// countdown
		UI.CountdownContainer.SetHasClass('Collapse', !JSON.Round.Countdown);
		UI.CountdownValue.text = JSON.Round.Countdown;	
		// round in progress
		UI.RoundInfoContainer.SetHasClass('Collapse', JSON.Round.Countdown);
		UI.RoundLevel.text = JSON.Round.Index;
		UI.RoundProgress.style.width = Math.round(JSON.Round.Progress * 100) + '%';
		UI.RoundTitle.text = $.Localize(JSON.Round.Title);
	} else {
		UI.CountdownContainer.SetHasClass('Collapse', true);
		UI.RoundInfoContainer.SetHasClass('Collapse', true);
	}
});


// update game info
GameEvents.Subscribe('ce_hud_update_gameinfo', function(JSON) {
	UI.LivesLeft.SetDialogVariableInt('lives', JSON.Lives);
	for (var key in JSON.Players) {
		UI.Heroes[key].heroname = JSON.Players[key].HeroName;
		UI.Heroes[key].SetHasClass('Dead', !JSON.Players[key].Alive);
	}
});