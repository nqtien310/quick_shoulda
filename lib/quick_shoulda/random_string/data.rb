module QuickShoulda
	module RandomString
		module Data
			StoredStrings = {
				:Emails       => ['us@gmail.com', 'us.vn@gmail.com', 'us_vn@gmail.com', 'us_vn@gmail.com.vn'],
				:Urls         => ['www.domain.com', 'www.domain.subdomain.com', 'http://www.domain.com', 'http://www.domain.subdomain.com', 
										  'http://www.domain.com/path/1',	'https://www.domain.com', 'https://www.domain.subdomain.com', 'domain.subdomain.com',
										  'domain.com/path/1', 'subdomain.domain.com/path/1'],
				:IPS          => ['192.168.1.1', '192.168.1.2'],
				:Sex          => ['male', 'female', 'gay', 'les', 'other'],
				:Zips         => ['10001', '10002', '10003'],
				:Phones       => ['732-757-2923', '1732-757-2923', '+84 121731845', '84 121731845', '(84) 121731845'],
				:Datetimes    => ['1999-01-01', '99-01-01', '1999/01/01', '99/01/01', '01/01/99', '03/10/1986', '01-01-1999', '01-01-99', 'January 07, 2013',
											'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday',
											'january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december',
											'am', 'pm'],
				:Countries    => ['Vietnam', 'America', 'England', 'Vietnamese', 'American', 'English'],
				:Cities       => ['New York', 'London', 'Ho Chi Minh'],
				:Statuses     => ['married', 'single', 'available', 'complicated'],
				:Files        => ['filename.txt', 'filename.jpg', 'filename.png', 'filename.jpeg'],
				:Extensions   => ['txt', 'jpg', 'png', 'jpeg', 'mp4', 'mp3', 'wmv'],
				:Videos       => ['filename.wmv', 'filename.mp4', 'filename.flv'],
				:CCNumbers    => ['4111 1111 1111 1111', '5500 0000 0000 0004', '3400 0000 0000 009', '3000 0000 0000 04'],
				:CCodes       => ['84', '1', '39'],
				:ISOCCodes    => ['US', 'USA', 'VN', 'VNM'],
				:Services     => ['yahoo', 'google', 'facebook', 'amazone', 'youtube', 'paypal', 'alchemy'],
				:Marks        => ['excellent', 'good', 'bad']
			}
		end
	end
end