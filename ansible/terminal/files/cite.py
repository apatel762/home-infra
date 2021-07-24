import argparse
import datetime
import sys

def is_empty(s: str) -> bool:
    return s is None or len(s) == 0

def today() -> str:
    return datetime.datetime.now().strftime('%B %d, %Y')

def convert_to_archive_org_link(link: str) -> str:
    if is_empty(link):
        return ''

    now: str = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
    return f'https://web.archive.org/web/{now}/{link}'

def create_citation_from_link(link: str) -> None:
    if link is None:
        print('You didnt provide a link to cite.')
        return
    if len(link) == 0:
        print('You didnt provide a valid link to cite.')
        return

    print(f'Citing: {link}')
    print('Please enter all of the below information')
    print('')

    author: str = input('Author (e.g. Patel, Arjun): ')
    publication_date: str = input('Publication Date (e.g. January 1, 1970): ')
    title: str = input('Title of page: ')

    print('')
    print('Thank you.')
    print('Generating Markdown citation...')
    print('')

    archived_link: str = convert_to_archive_org_link(link)

    # build citation string
    citation: str = ''
    if is_empty(author):
        citation += 'unascribed'
    else:
        citation += f'{author}'

    if is_empty(publication_date):
        citation += '.'
    else:
        citation += f' ({publication_date}).'

    citation += ' '

    if is_empty(title):
        citation += f'<{link}>'
    else:
        citation += f'"[{title}]({link})".'

    citation += ' ' + f'*[Archived]({archived_link})*.'
    citation += ' ' + f'Retrieved {today()}.'

    print('')
    print('Dont forget to check the archived link to see if anything exists there')
    print('')

    sys.stdout.write(citation)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Create a web citation from a URL')
    parser.add_argument(
        'url',
        type=str,
        help='The URL that you want to create a web citation for')
    args: argparse.Namespace = parser.parse_args()

    create_citation_from_link(link=args.url)
