#!/usr/bin/env python

import os
import sys

import utils
import utils_flickr
import utils_image

__author__ = 'Fatma Imamoglu'
__email__ = 'fatma@berkeley.edu'
__status__ = 'Development'

def crmooney_fromdb(api_key, api_secret, search_words, imagepath='', mooneypath='', dbname='flickr', search_tags=[], 
    license='2', size='original', content_type=1, media='photos', sort='relevance', pages_to_get=[1,2], per_page=50, 
    resize=0, smooth_sigma=6, image_size=(400,400), threshold_method='global_otsu'):
    """ Given an API key and secret, and search words, download images from image db, create Mooney imagse and save Mooney images in the directory specified with 
        mooneypath.

    Input:
        api_key: API key of the online image database.
        api_secret: API secret of the online image database.
        search_words: A list of search words. These words will be used in the specified image database as search words.
        imagepath: Path where the downloaded images should be saved.
        mooneypath: Path where the Mooney images should be saved.
        dbname: Online image database identifier. Default: 'flickr' (others to be implemented.)
        search_tags: Similar to search words. Could be used to further resitrict the search results.
        license: String of numbers. (check: utils_flickr.get_license_info())

    Returns:
        imgs_mooney: A dictionary of Mooney images along with the threshold value, its original path and original image name.
    """

    if imagepath == '':
        imagepath = os.getcwd()

    ## Connect to API
    if dbname == 'flickr':  ### Else to come
        ## Use API implementation by Beej's Python Flickr API
        api = utils.connect_api(dbname, api_key, api_secret)

        ## Print general license information
        utils_flickr.get_license_info(api)
        print('You choice of license: {}. \n Set "license" if you want to change this.'.format(license))

    imgs_mooney = []
    photo_meta = []
    for search_word in search_words:

        search_tag = search_word
        'Image search in {0}. \n \t search word: \t {1}'.format(dbname, search_word)
    
        ## Search and store metadata
        pages = [api.photos.search(text=search_word, tag=search_tag, license=license, content_type=content_type, media=media, per_page=per_page, page=p) for p in pages_to_get]
        for page in pages:
            for photo in page['photos']['photo']:
                meta = utils_flickr.get_metadata(api, photo)
                photo_meta.append(meta)

    ## Save metadata
    filename = os.path.join(imagepath,'flickr_download_metadata')
    utils.write_metadata(photo_meta, filename, format='json')

    ## Download and create Mooney images
    counter = 1
    for photo in photo_meta:
        if (counter % 50 == 0):
            '\t\t {0}/{1} downloaded.'.format(counter, len(photo_meta))
        if size == 'original':
            url = photo['original']['source']
        elif size == 'large_square':
            url = photo['large_square']['source']
        
        filename = os.path.join(imagepath, url.split('/')[-1])
        imgname = os.path.basename(filename)

        # Download image
        utils.get_image(url, filename)

        # Load image
        img = utils_image.load_imgs(filename)
        img = img[imgname]

        # Convert to gray scale image
        if len(img.shape) > 2:
            img = utils_image.rgb2gray(img)
            fname = os.path.join(mooneypath, imgname.split('.')[0]+'_g.'+imgname.split('.')[1])
            utils_image.save_img(img, fname)

        # Resize image
        if resize:
            img = utils_image.resize(img, size=image_size)
            fname = os.path.join(mooneypath, imgname.split('.')[0]+'_gr.'+imgname.split('.')[1])
            utils_image.save_img(img, fname)

        # Smooth image
        img = utils_image.gauss_filter(img, sigma=smooth_sigma)
        fname = os.path.join(mooneypath, imgname.split('.')[0]+'_s.'+imgname.split('.')[1])
        utils_image.save_img(img, fname)

        # Create Mooney image
        img, threshold = utils_image.threshold_img(img, method=threshold_method)
        fname = os.path.join(mooneypath, imgname.split('.')[0]+'_m.'+imgname.split('.')[1])
        utils_image.save_img(img, fname)

        # Store resulting image in a dict
        imgs_mooney.append({
            'img_id':photo['photo_id'],
            'img_name':os.path.basename(filename).split('.')[0],
            'img_mooney':img,
            'threshold':threshold,
            'threshold_method':threshold_method,
            'resize':resize,
            'smooth_sigma':smooth_sigma,
            'url':url,
            'mooneypath':mooneypath,
            'imagepath':imagepath
            })

        counter += 1

    '{0} images are downloaded in {1}. \n Mooneys are in {2} and in the return variable'.format(len(imgs_mooney), imagepath, mooneypath)
    return imgs_mooney, photo_meta

def crmooney_frompath(filename, mooneypath='', resize=0, smooth_sigma=4, image_size=(400,400), threshold_method='global_otsu'):

    """ Given a path create and save Mooney images in the directory specified with 

    Input:
        filename: Can be a directory (in which case all the .JPG files will be converted to Mooney) or the path of the jpg file.
        mooneypath: Path to save the final Mooney image.

    Returns:
        imgs_mooney: A dictionary of Mooney images along with the threshold value, its original path and original image name.
    """

    if mooneypath=='':
        if not os.path.dirname(filename)=='':
            mooneypath = os.path.dirname(filename)
        else:
            mooneypath = os.getcwd()
    print(mooneypath)    
    # Load image
    imgs = utils_image.load_imgs(filename)

    imgs_mooney = []
    
    for imgname, img in imgs.items():

        # Convert to gray scale image
        if len(img.shape) > 2:
            img = utils_image.rgb2gray(img)
            fname = os.path.join(mooneypath, imgname.split('.')[0]+'_g.'+imgname.split('.')[1])
            utils_image.save_img(img, fname)

        # Resize image
        if resize:
            img = utils_image.resize(img, size=image_size)
            fname = os.path.join(mooneypath, imgname.split('.')[0]+'_gr.'+imgname.split('.')[1])
            utils_image.save_img(img, fname)

        # Smooth image
        img = utils_image.gauss_filter(img, sigma=smooth_sigma)
        fname = os.path.join(mooneypath, imgname.split('.')[0]+'_s.'+imgname.split('.')[1])
        #utils_image.save_img(img, fname)

        # Create Mooney image
        img, threshold = utils_image.threshold_img(img, method=threshold_method)
        fname = os.path.join(mooneypath, imgname.split('.')[0]+'_a.'+imgname.split('.')[1])
        utils_image.save_img(img.astype('float'), fname)

        # Store images in a dict
        imgs_mooney.append({
            'img_name':imgname.split('.')[0],
            'img_mooney':img,
            'threshold':threshold,
            'threshold_method':threshold_method,
            'resize':resize,
            'smooth_sigma':smooth_sigma,
            'mooneypath':mooneypath,
            'imagepath':os.path.dirname(filename),
            })

    print('{0} Mooney images are in {1} and in the return variable'.format(len(imgs_mooney), mooneypath))
    return imgs_mooney

if __name__ == '__main__':


    ## Use search words to search images in Flickr image database
    try:
        os.path.exists(sys.argv[1])
        print('Search words read from file: {}'.format(sys.argv[1]))
        search_words = utils.read_file(sys.argv[1])
    except:
        search_words = ['cat']

    # Flickr-API authentication keys. 
    # Get your own before using this from https://www.flickr.com/services/api/
    API_KEY = 'f0469ee21918df5d9adf3af366068430'
    API_SECRET = '6ee6ffc3659eed38'
    try:
        API_KEY, API_SECRET
        'Good news, you have API_KEY and API_SECRET defined. You are ready to go.'

        license = '2' # 2: "Attribution-NonCommercial License", 4: "Attribution License"
        imagepath = os.path.join(os.getcwd(), 'images', 'flickr')
        mooneypath = os.path.join(imagepath, 'mooney')

        imgs, metadata = crmooney_fromdb(api_key=API_KEY, api_secret=API_SECRET, search_words=search_words, 
                    imagepath=imagepath, mooneypath=mooneypath, dbname='flickr', search_tags=[], 
                    license=license, size='original', content_type=1, media='photos', sort='relevance', 
                    pages_to_get=[1], per_page=2, resize=0, smooth_sigma=6, image_size=(400,400), threshold_method='global_otsu')

    except NameError:
        ## Create images from a given path
        'You need an API_KEY and API_SECRET to continue. \n Check https://www.flickr.com/services/api'
        imagepath = os.path.join(os.getcwd(), 'images')

        '------------ or:'
        choice = raw_input('\n Press [ENTER] if you want to convert images in {} \n Press [c] to cancel \n'.format(imagepath))
        if choice == '':
            mooneypath = os.path.join(imagepath, 'mooney')
            imgs = crmooney_frompath(imagepath, mooneypath=mooneypath, 
                        resize=0, smooth_sigma=6, image_size=(400,400), threshold_method='global_otsu')
