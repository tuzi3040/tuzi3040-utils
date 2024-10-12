$notification.post("Notification Test","Notification Test", (new Date($script.startTime * 1000)).toISOString());
$done({response: {status: 204}});
