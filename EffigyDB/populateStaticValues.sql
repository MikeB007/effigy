-- INSERT MEDIATYPES
insert into media_type values('P','PICTURE');
insert into media_type values('V','VIDEO');
insert into media_type values('A','AUDIO');
-- INSERT EXTENSION TYPES
insert into supported_ext values('.jpg','');
insert into supported_ext values('.jpeg','');
insert into supported_ext values('.avi','');
insert into supported_ext values('.mpg','');
insert into supported_ext values('.wmv','');
insert into supported_ext values('.png','');
insert into supported_ext values('.mp4','');
insert into supported_ext values('.mov','');
insert into supported_ext values('.mp3','');

insert into skip_root values(null,'Y:\\server\\EFFIGY_PICS\\Zdjecia\\tomcat-ZDJECIA');
insert into skip_root values(null,'Y:\\server\\EFFIGY_PICS2\\Zdjecia\\tomcat-ZDJECIA');


insert into media_type_ext values(Null,'P','.jpg');
insert into media_type_ext values(Null,'P','.jpeg');
insert into media_type_ext values(Null,'V','.avi');
insert into media_type_ext values(Null,'V','.mpg');
insert into media_type_ext values(Null,'V','.wmv');
insert into media_type_ext values(Null,'P','.png');
insert into media_type_ext values(Null,'V','.mp4');
insert into media_type_ext values(Null,'V','.mov');
insert into media_type_ext values(Null,'A','.mp3');
