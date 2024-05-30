import requests
import os

load_to_directory = "assets/icons/weather"

base_url = "http://openweathermap.org/img/wn"

name_prefixes = ["01", "02", "03", "04", "09", "10", "11", "13", "50"]
name_suffixes = ["d", "n"]

def main():
    if not os.path.exists(load_to_directory):
        os.makedirs(load_to_directory+'/2.0x/')
        os.makedirs(load_to_directory+'/4.0x/')
    icon_names = [f'{prefix}{suffix}' for prefix in name_prefixes for suffix in name_suffixes]
    for icon_name in icon_names:
        url_1x = f'{base_url}/{icon_name}.png'
        url_2x = f'{base_url}/{icon_name}@2x.png'
        url_4x = f'{base_url}/{icon_name}@4x.png'
        _1x = requests.get(url_1x)
        _2x = requests.get(url_2x)
        _4x = requests.get(url_4x)
        with open(f'{load_to_directory}/{icon_name}.png', 'wb') as f:
            f.write(_1x.content)
        with open(f'{load_to_directory}/2.0x/{icon_name}.png', 'wb') as f:
            f.write(_2x.content)
        with open(f'{load_to_directory}/4.0x/{icon_name}.png', 'wb') as f:
            f.write(_4x.content)

if __name__ == '__main__':
    main()