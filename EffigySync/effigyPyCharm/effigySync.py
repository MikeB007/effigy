import os
from datetime import datetime
import time
from mysql.connector import errorcode
from PIL import Image
import mysql.connector

from dateutil.parser import parse
import logging

import glob
import shutil
import sys, getopt

logging.basicConfig(level=logging.DEBUG, filename='Effigy.log', format='%(asctime)s %(name)s %(levelname)s:%(message)s')
logger = logging.getLogger(__name__)

SOURCEPATH = 'D:/server/3_TB_DRIVE'
#SOURCEPATH = 'D:/server/TEST'

# SOURCEPATH='Y:/server/EFFIGY_PICS2'
# SOURCEPATH = 'C:/Users/user/Pictures'
MISSING = ''
MISSING_0 = '0'
MISSING_DT = '2100-01-01 0:0:0'
MIN_IMAGE_SIZE = 4000
DBSERVER="192.168.0.111"
DATABASE = 'effigy3'
USER = 'mediaUser'
PASSWORD = 'password'
COLLECTION_ID = 3
COLLECTION_DESC = '3TB DRIVE_TEST'

def ConvertListToDic(lst):
    res_dct = {lst[i]: lst[i + 1] for i in range(0, len(lst), 2)}
    return res_dct

def fixSlashes(val):
    val = val.replace('\\', '/')
    return val

def getDt():
    now = datetime.now()
    dt = now.strftime('%Y-%m-%d %H:%M:%S')
    return (dt)

getDt()

def getFileCreationTime(file):
    d = datetime.utcfromtimestamp(os.path.getctime(file)).strftime("%Y/%m/%d %H:%M:%S")
    return (d)

def getFileModificationTime(file):
    d = datetime.utcfromtimestamp(os.path.getmtime(file)).strftime("%Y/%m/%d %H:%M:%S")
    return (d)

# cust_isDate(dt)
def custom_is_date(string, fuzzy=False):
    """
    Return whether the string can be interpreted as a date.

    :param string: str, string to check for date
    :param fuzzy: bool, ignore unknown tokens in string if True
    """
    try:
        parse(string, fuzzy=fuzzy)
        return True

    except ValueError:
        return False


a = set()
# folders = []
# r=root, d=directories, f = files
for r, d, f in os.walk(SOURCEPATH):
    for f1 in f:
        ext = os.path.splitext(f1)[1]
        a.add(ext)

def createThumbnailss(srcPath, destPath, size=120):
    for infile in glob.glob(srcPath):
        print("infile", infile)
        file, ext = os.path.splitext(infile)
        print(file, ext)
        print(destPath)
        im = Image.open(infile)
        im.thumbnail(size, size)
        im.save(destPath + "/thumbnail1.png", "PNG")

def getID(tbl, thisid, key, val):
    try:
        mydb = mysql.connector.connect(user=USER, password=PASSWORD, host=DBSERVER, database=DATABASE,
                                       auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        ssql = "select " + thisid + " from " + tbl + " where " + key + "= %s"
        # print (ssql)
        mycursor.execute(ssql, (val,))
        rows = mycursor.fetchall()
        columns = [desc[0] for desc in mycursor.description]
        newid = []
        for row in rows:
            # we dont need json or column names only one row returned
            # row = dict(zip(columns, row))
            newid.append(row)
    except Exception as err:
        logger.error(err)
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            custError = "Something is wrong with your user name or password" + val
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            custError = "Database does not exists"
        else:
            custError = err
        print(custError)
        logger.error(custError)
        mycursor.close()
        mydb.close()
    else:
        custError = "getID - Completed OK!:" + str(val)
        logger.info(custError)
        mycursor.close()
        mydb.close()
        logger.info("getID DB Closed" + str(val))
        # obejct is a tuple we retrieve only id
        #print(newid)
        if len(newid) >= 1:
            id = newid[0][0]
        else:
            id = -1
        return (id)

def getImageID(tbl, thisid, key, val, key2, val2):
    try:
        mydb = mysql.connector.connect(user=USER, password=PASSWORD, host=DBSERVER, database=DATABASE,
                                       auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        ssql = "select " + thisid + " from " + tbl + " where " + key + "= %s and  " + key2 + "= %s"
        # print (ssql)
        mycursor.execute(ssql, (fixSlashes(val), val2,))
        rows = mycursor.fetchall()
        columns = [desc[0] for desc in mycursor.description]
        newid = []
        for row in rows:
            # we dont need json or column names only one row returned
            # row = dict(zip(columns, row))
            newid.append(row)
    except Exception as err:
        logger.error(err)
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            custError = "Something is wrong with your user name or password" + val
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            custError = "Database does not exists"
        else:
            custError = err
        print(custError)
        logger.error(custError)
        mycursor.close()
        mydb.close()
    else:
        custError = "getID - Completed OK!:" + val
        logger.info(custError)
        mycursor.close()
        mydb.close()
        logger.info("getID DB Closed" + val)
        # obejct is a tuple we retrieve only id
        #print(newid)
        if len(newid) >= 1:
            id = newid[0][0]
        else:
            id = -1
        return (id)


def getValidExtensions():
    try:
        mydb = mysql.connector.connect(user=USER, password=PASSWORD, host=DBSERVER, database=DATABASE,
                                       auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        ssql = "select extension from supported_ext order by 1"
        mycursor.execute(ssql)
        rows = mycursor.fetchall()
        columns = [desc[0] for desc in mycursor.description]
        rec = []
        for row in rows:
            # we dont need json or column names only one row returned
            # row = dict(zip(columns, row))
            rec.append(row)
    except Exception as err:
        logger.error(err)
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            custError = "Something is wrong with your user name or password" + val
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            custError = "Database does not exists"
        else:
            custError = err
        print(custError)
        logger.error(custError)
        mycursor.close()
        mydb.close()
    else:
        custError = "getID - Completed OK!:"
        logger.info(custError)
        mycursor.close()
        mydb.close()
        logger.info("getID DB Closed")
        # converting it to a SET, fast lookup
        ext_set = set()
        for i in rec:
            ext_set.add(i[0])
        return (ext_set)

def getValidMediType_Extensions():
    try:
        mydb = mysql.connector.connect(user=USER, password=PASSWORD, host=DBSERVER, database=DATABASE,
                                       auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        ssql = "select extension, media_type_id from media_type_ext order by 1"
        mycursor.execute(ssql)
        rows = mycursor.fetchall()
        columns = [desc[0] for desc in mycursor.description]
        rec = []
        for row in rows:
            # we dont need json or column names only one row returned
            # row = dict(zip(columns, row))
            rec.append(row)
    except Exception as err:
        logger.error(err)
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            custError = "Something is wrong with your user name or password" + val
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            custError = "Database does not exists"
        else:
            custError = err
        print(custError)
        logger.error(custError)
        mycursor.close()
        mydb.close()
    else:
        custError = "getID - Completed OK!:"
        logger.info(custError)
        mycursor.close()
        mydb.close()
        logger.info("getID DB Closed")
        return (dict(rec))

r = getValidMediType_Extensions()
r.get('.avi')

def getSkipFolder():
    try:
        mydb = mysql.connector.connect(user=USER, password=PASSWORD, host=DBSERVER, database=DATABASE,
                                       auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        ssql = "select skip_root from skip_root"
        mycursor.execute(ssql)
        rows = mycursor.fetchall()
        columns = [desc[0] for desc in mycursor.description]
        rec = []
        for row in rows:
            # we dont need json or column names only one row returned
            # row = dict(zip(columns, row))
            rec.append(row)
    except Exception as err:
        logger.error(err)
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            custError = "Something is wrong with your user name or password" + val
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            custError = "Database does not exists"
        else:
            custError = err
        print(custError)
        logger.error(custError)
        mycursor.close()
        mydb.close()
    else:
        custError = "getID - Completed OK!:"
        logger.info(custError)
        mycursor.close()
        mydb.close()
        logger.info("getID DB Closed")
        # converting it to a SET, fast lookup
        _set = set()
        for i in rec:
            _set.add(i[0])
        return (_set)

getSkipFolder()

def convertTuple(tup):
    str1 = ''.join(str(tup))
    return str1

# get valid extensions
EXT = getValidExtensions()


def insertRoot(root):
    logger.info("Starting Request")
    try:
        mydb = mysql.connector.connect(user=USER, password=PASSWORD, host=DBSERVER, database=DATABASE,
                                       auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        ssql = "insert into loc_root values (null, %s,%s,%s,%s,%s)"
        root = fixSlashes(root)
        # print (root)
        mycursor.execute(ssql, (root, '', COLLECTION_ID, COLLECTION_DESC, getDt(),))
        mydb.commit()
        # get newly created ID
        newid = getID("loc_root", "root_id", "root", fixSlashes(root))
    except Exception as err:
        logger.error(err)
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            custError = "Something is wrong with your user name or password"
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            custError = "Database does not exists"
        else:
            custError = err
        print(custError)
        logger.error(custError)
        mycursor.close()
        mydb.close()
    else:
        custError = "Root-Completed OK!"
        logger.info(custError)
        mycursor.close()
        mydb.close()
        logger.info("Root - DB Closed")
        return (newid)


def insertFolder(root_id, root, folder, folderPath):
    logger.info("Starting Request")
    try:
        mydb = mysql.connector.connect(user=USER, password=PASSWORD, host=DBSERVER, database=DATABASE,
                                       auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        ssql = "insert into loc_folder values (null,%s, %s,%s,%s,%s,%s)"
        root = fixSlashes(root)
        folder = fixSlashes(folder)
        folderPath = fixSlashes(folderPath)
        # print (ssql)
        mycursor.execute(ssql, (root_id, root, folder, folderPath, '', getDt(),))
        mydb.commit()
        # get newly created ID
        newid = getID("loc_folder", "folder_id", "folder_path", fixSlashes(folderPath))
    except Exception as err:
        logger.error(err)
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            custError = "Something is wrong with your user name or password"
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            custError = "Database does not exists"
        else:
            custError = err
        print(custError)
        logger.error(custError)
        mycursor.close()
        mydb.close()
    else:
        custError = "Folder Completed OK!"
        logger.info(custError)
        mycursor.close()
        mydb.close()
        logger.info("Folder check DB Closed")
        return (newid)

def skipRoot(root):
    skip = False
    toSkip = "Y:\server\EFFIGY_PICS\Zdjecia\\tomcat-ZDJECIA"
    if len(root) >= len(toSkip):
        if (fixSlashes(toSkip).upper() == fixSlashes(root[:len(toSkip)]).upper()):
            skip = True
    # else:
    #    print("not matching length")
    return (skip)

def skipFolder(root):
    skip = False
    toSkip = getSkipFolder()
    for folder in toSkip:
        if len(root) >= len(folder):
            # print(folder)
            # print(fixSlashes(folder).upper())
            # print(fixSlashes(root[:len(folder)]).upper())
            if (fixSlashes(folder).upper() == fixSlashes(root[:len(folder)]).upper()):
                skip = True
                return (skip)
    return (skip)

def insertImage(key, file_name, media_type, folder_id, path, parent_folder_id, parent_folder, attrib_id, ext, dttaken,
                dtmodified, size):
    logger.info("Saving image")
    # print(key,file_name,media_type,folder_id,path, parent_folder_id,parent_folder,attrib_id,ext)
    try:
        mydb = mysql.connector.connect(user=USER, password=PASSWORD, host=DBSERVER, database=DATABASE,
                                       auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        ssql = "insert into media values (null,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
        path = fixSlashes(path)
        parent_folder = fixSlashes(parent_folder)
        # print (ssql)
        mycursor.execute(ssql, (
        key, file_name, media_type, folder_id, path, parent_folder_id, parent_folder, "sDesc", file_name, 0, ext, size,
        dttaken, dtmodified, getDt(), getDt()))
        mydb.commit()
        # get newly created ID
        newid = getImageID("media", "media_id", "path", path, "name", file_name)
    except Exception as err:
        logger.error(err)
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            custError = "Something is wrong with your user name or password"
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            custError = "Database does not exists"
        else:
            custError = err
        print(custError)
        logger.error(custError)
        mycursor.close()
        mydb.close()
    else:
        custError = "Folder Completed OK!"
        logger.info(custError)
        mycursor.close()
        mydb.close()
        logger.info("Folder check DB Closed")
        return (newid)

def getExifDate(pth, ext):
    exif = {}
    ex = ""
    dic = {}
    # check if image
    mdt = '2090-01-01 0:0:0'
    if ext == 'P':
        # Read image
        try:
            mdt = getFileModificationTime(pth)
            cdt = getFileCreationTime(pth)
            img = Image.open(pth)
            dic = img._getexif()
            # check if empty
        except Exception as err:
            print("issue processing" + pth)
            print(err)
            logger.error(err)
            print("WIDTH", pth)
    if dic:

        exif["DTTAKEN"] = str(dic.get(36868))
        exif["DTMODIFY"] = str(dic.get(36867))

    else:
        exif["DTTAKEN"] = MISSING_DT
        exif["DTMODIFY"] = MISSING_DT

    if exif["DTTAKEN"] == exif["DTMODIFY"]:
        if custom_is_date(mdt):
            exif["DTMODIFY"] = mdt
            if  not custom_is_date(exif["DTTAKEN"]) :
                exif["DTTAKEN"]= mdt
    return (exif)

def importFoldersAndImages():
    # get Valid extensions first
    c = 0
    i=0
    EXT = getValidExtensions()
    EXTTypeDic = getValidMediType_Extensions()
    #  check
    '' in EXT
    # print(EXT)
    for r, d, f in os.walk(SOURCEPATH):
        #print("dir",d,r)
        c=c+1
        if len(d) > 0:
            if skipRoot(r):
                print("Skipped Root:", r)
            else:
                idR = insertRoot(r)
                # print("Processed Root:",idR,r)
                for dir in d:
                    # print ("will INSERT dir:",idR,dir)
                    # print("about to insert", idR,r,dir,r + '/' + dir)
                    idF = insertFolder(idR, r, dir, r + "/" + dir)
                    # print("Created folder",idF)
                    pth = r + "/" + dir
                    #print("path", pth)
                    files = [f for f in os.listdir(pth) if os.path.isfile(os.path.join(pth, f))]
                    for f in files:
                        file_ext = os.path.splitext(f)[1].lower()
                        key = fixSlashes(r + "/" + dir + "/" + f)
                        size = os.path.getsize(key)
                        # print("size", size,file_ext)
                        if (file_ext in EXT) and size > MIN_IMAGE_SIZE:
                            mediaType = EXTTypeDic.get(file_ext)
                            exif = getExifDate(key, mediaType)
                            dttaken = exif["DTTAKEN"]
                            dtmodified = exif["DTMODIFY"]
                            i = i + 1
                            if (i) % 200 == 0:
                                print("Processed Images:" + str(i))
                            # print("Processing:" + f)
                            # inserImage(file_name,media_type,folder_id,path, parent_folder_id,parent_folder,attrib_id,ext):
                            idM = insertImage(key, f, mediaType, idF, r + "/" + dir, idR, r, "", file_ext, dttaken,
                                              dtmodified, size)
                            # print(idM)

    return (i)

c = importFoldersAndImages()

print("total:", c)

def getImageExifAttributes(pth, ext):
    exif = {}
    ex = ""
    dic = {}
    # check if image
    mdt = '2090-01-01 0:0:0'
    if ext == 'P':
        # Read image
        try:
            #print(pth)
            mdt = getFileModificationTime(pth)
            cdt = getFileCreationTime(pth)
            img = Image.open(pth)
            dic = img._getexif()
            # check if empty
        except Exception as err:
            print("issue processing" + pth)
            print(err)
            logger.error(err)
            print("WIDTH", pth)
    if dic:

        if str(dic.get(40963)).isnumeric():
            exif["WIDTH"] = str(dic.get(40963))
        else:
            exif["WIDTH"] = str('0')

        exif["HEIGHT"] = str(dic.get(40962))
        exif["CAMERA"] = str(dic.get(271))
        exif["MODEL"] = str(dic.get(272))
        exif["DTTAKEN"] = str(dic.get(36868))
        exif["DTMODIFY"] = str(dic.get(36867))
        exif["FSTOP"] = str(dic.get(42036))
        exif["EXPOSURE"] = str(dic.get(40960))
        exif["ORIENTATION"] = str(dic.get(274))
        exif["FLASH"] = str(dic.get(7385))
        exif["SHUTTER"] = str(dic.get(37377))
        exif["APERTURE"] = str(dic.get(37378))
        exif["ISOSPEED"] = str(dic.get(34855))
        exif["DIGIZOOM"] = str(dic.get(41988))
        # print("FSTOP",exif["FSTOP"])
        for x in dic:
            if x != 37500 and x != 37510:
                ex = ex + (str(x) + ":" + str(dic.get(x)) + chr(13) + chr(10))
                # limit to 5K
        exif["EXIF"] = str(ex)[0:5000]
    else:
        exif["WIDTH"] = MISSING_0
        exif["HEIGHT"] = MISSING_0
        exif["CAMERA"] = MISSING
        exif["MODEL"] = MISSING
        exif["DTTAKEN"] = MISSING_DT
        exif["DTMODIFY"] = MISSING_DT
        exif["FSTOP"] = MISSING
        exif["EXPOSURE"] = MISSING
        exif["ORIENTATION"] = MISSING
        exif["FLASH"] = MISSING
        exif["SHUTTER"] = MISSING
        exif["APERTURE"] = MISSING
        exif["ISOSPEED"] = MISSING
        exif["DIGIZOOM"] = MISSING
        exif["EXIF"] = MISSING

    # overwrite mod date is wrong
    # print("From File Modify:",mdt)
    # print("From File Create:",cdt)
    # print("From exif Modify:",exif["DTMODIFY"])
    # print("From exif Create:",exif["DTTAKEN"])
    exif["DTMODIFY"]
    if exif["DTTAKEN"] == exif["DTMODIFY"]:
        if custom_is_date(mdt):
            exif["DTMODIFY"] = mdt
            if not custom_is_date(exif["DTTAKEN"]):
                exif["DTTAKEN"]= mdt
    return (exif)



def getImages():
    try:
        mydb = mysql.connector.connect(user=USER, password=PASSWORD, host=DBSERVER, database=DATABASE,
                                       auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        ssql = "select media_id,path, name, media_key,media_type_id from media"
        # print (ssql)
        mycursor.execute(ssql)
        rows = mycursor.fetchall()
        columns = [desc[0] for desc in mycursor.description]
        rec = []
        for row in rows:
            # we dont need json or column names only one row returned
            # row = dict(zip(columns, row))
            rec.append(row)
    except Exception as err:
        logger.error(err)
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            custError = "Something is wrong with your user name or password" + val
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            custError = "Database does not exists"
        else:
            custError = err
        print(custError)
        logger.error(custError)
        mycursor.close()
        mydb.close()
    else:
        custError = "getID - Completed OK!:"
        logger.info(custError)
        mycursor.close()
        mydb.close()
        logger.info("getID DB Closed")
        _set = set()
        for i in rec:
            _set.add(i)
        return (_set)

#getImageExifAttributes('Y:/server/EFFIGY_PICS2/Zdjecia/DCP_0474.JPG', 'P')

def insertMediaAttributes(width, height, camera, model, dttaken, dtmodify, fstop, exposure, orientation, flash, shutter,
                          aperture, isospeed, digizoom, exif, media_id, media_key):
    logger.info("Saving Attributes" + media_key)
    # print(key,file_name,media_type,folder_id,path, parent_folder_id,parent_folder,attrib_id,ext)
    try:
        mydb = mysql.connector.connect(user=USER, password=PASSWORD, host=DBSERVER, database=DATABASE,
                                       auth_plugin='mysql_native_password')
        mycursor = mydb.cursor()
        ssql = "insert into attrib values (null,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
        # print (ssql)
        mycursor.execute(ssql, (
        width, height, camera, model, dttaken, dtmodify, fstop, exposure, orientation, flash, shutter, aperture,
        isospeed, digizoom, exif, media_id, media_key, getDt()))
        mydb.commit()
        # get newly created ID
        newid = getID("attrib", "attrib_id", "media_id", media_id)
    except Exception as err:
        logger.error(err)
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            custError = "Something is wrong with your user name or password"
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            custError = "Database does not exists"
        else:
            custError = err
        print(custError)
        logger.error(custError)
        mycursor.close()
        mydb.close()
    else:
        custError = "Folder Completed OK!"
        logger.info(custError)
        mycursor.close()
        mydb.close()
        logger.info("Folder check DB Closed")
        return (newid)


def ProcessAttributes():
    i= 0
    img_set = getImages()
    for media_id, path, fname, media_key, media_type_id in img_set:
        pth = fixSlashes(path + "/" + fname)
        # print(pth)
        if media_type_id == 'P':
            exif = getImageExifAttributes(pth, media_type_id)
            size = os.path.getsize(pth)
            # print("size", size)
            if size > MIN_IMAGE_SIZE:
                i=i+1
                if (i)%200==0:
                    print("Processed with Attributes:" + str(i))
                idA = insertMediaAttributes(exif["WIDTH"], exif["HEIGHT"], exif["CAMERA"], exif["MODEL"],
                                            exif["DTTAKEN"], exif["DTMODIFY"], exif["FSTOP"], exif["EXPOSURE"],
                                            exif["ORIENTATION"], exif["FLASH"], exif["SHUTTER"], exif["APERTURE"],
                                            exif["ISOSPEED"], exif["DIGIZOOM"], exif["EXIF"], media_id, media_key)

ProcessAttributes()

