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

function hudUpdate(JSON) {
	UI.RoundInfoContainer.SetHasClass('Collapse', JSON.Countdown.Enabled);
	UI.RoundLevel.text = JSON.Round.Level;
	UI.RoundProgress.style.width = Math.round(JSON.Round.Progress * 100) + '%';
	UI.RoundTitle.text = JSON.Round.Title;
	for (var key in JSON.Players) {
		UI.Heroes[key].heroname = JSON.Players[key].HeroName;
		UI.Heroes[key].SetHasClass('Dead', !JSON.Players[key].Alive);
	}
	UI.LivesLeft.SetDialogVariableInt('lives', JSON.Lives);
	UI.CountdownContainer.SetHasClass('Collapse', !JSON.Countdown.Enabled);
	UI.CountdownValue.text = JSON.Countdown.Value;
}

function AddNotification(JSON) {
	var notification = $.CreatePanel('Label', UI.NotificationsRoot, '');
	notification.hittest = false;
	notification.html = true;
	notification.text = JSON.Text;
	$.Schedule(!isNaN(parseFloat(JSON.Duration)) && isFinite(JSON.Duration) ? JSON.Duration : 3, function() {
		notification.DeleteAsync(0);
	});

}

GameEvents.Subscribe('ce_hud_update', hudUpdate);
GameEvents.Subscribe('ce_notification', AddNotification);