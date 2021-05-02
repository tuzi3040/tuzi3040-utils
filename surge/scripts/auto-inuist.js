const u = 'xxxxxxxxxxxxx'; //username
const c = 'xxxx'; //domain
const pw = 'xxxxxxxx'; //password in Base64

function g() {
	return new Promise((resolve, reject) => {
		$httpClient.get('http://10.255.255.13/index.php/index/init', (e, r, d) => {
			if (e === null) {
				if (r.status === 200) {
					resolve(JSON.parse(d).status);
				} else {
					reject(r.status);
				}
			} else {
				reject(e);
			}
		});
	});
}

function p() {
	return new Promise((resolve, reject) => {
		$httpClient.post({
			url: 'http://10.255.255.13/index.php/index/login',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded',
			},
			body: `username=${u}&domain=${c}&password=${pw}&enablemacauth=0`
		}, (e, r, d) => {
			if (e === null) {
				if (r.status === 200) {
					if (JSON.parse(d).status === 1){
						resolve();
					} else {
						reject(JSON.parse(d).info);
					}
				} else {
					reject(r.status);
				}
			} else {
				reject(e);
			}
		});
	});
}

function sleep(t) {
	return new Promise((r) => {setTimeout(r, t);});
}

async function r(f, n = 3) {
	let l;
	for (let i = 0; i < n; i++) {
		try {
			return await f();
		} catch (e) {
			l = e;
			await sleep(500);
		}
	}
	console.log(`${$script.name} func ${f.name}() Login failed after retry. ${l}`);
	$notification.post($script.name, `func ${f.name}()`, `Login failed after retry.\n${l}`);
	$done();
}

async function m() {
	try {
		if ($network.wifi.ssid === 'i-NUIST' || $network.wifi.ssid === 'xxxxxxxxxx' || $network.wifi.ssid === 'xxxxxxxxxx') { //other ssid
			if ($script.startTime.getHours() >= 7 && $script.startTime.getHours() <= 23) {
				if (await r(g) === 0) {
					await r(p);
				}
			}
		}
	} catch (e) {
		console.log(`${$script.name} ${e}`)
		$notification.post($script.name, 'Exception caught', e);
	} finally {
		$done();
	}
}

m();
