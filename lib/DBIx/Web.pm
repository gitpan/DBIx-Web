#!perl -w
#
# DBIx::Web - Active Web Database Layer
#
# makarow@mail.com, started 2003-09-16
#
# Future ToDo:
# - development of cgi-bus remake
# - smtp mailer
# ? mandatory fields
# - htmlMenu scroll
# - !!! review
# - code review
# - ui: changes display, but what differ and how in html?
# - 'recRead' alike calls may return an objects, knows metadata
#
# Problems - Think:
#
#
# ToDo:
# - periodical trigger and chk-out state
# - test/debug 'webus.cgi'&'web.cgi': behaviour, versioning, checkouts, attachments, triggers transformation
#
# Done:
# 2005-06-18 cgiQuery: -query respecification
# 2005-06-18 cgiQuery: reoganized -qfrmLso -> -frmLso
# 2005-06-18 cgiParse: recQBF -qlist -> recList -form
# 2005-06-18 recSel: new -query, removed -display, -data, -field
# 2005-06-18 reoganized -qlist -> -recQBFl, it is in doubt at all
# 2005-06-18 reoganized -qform -> -recQBF
# 2005-06-16 cgiForm: new -qform form description
# 2005-06-15 rfdPath '/rfa' usage correctn
# 2005-06-14 rfdStamp considering usernames from missed local domains
# 2005-06-12 webus gwo testing
# 2005-06-12 webus gwo 'period'
# 2005-06-10 message translation into russian
# 2005-06-10 htmlMenu recNew/recIns decoration alike recEdit/recUpd
# 2005-06-10 new -labels_LL for 'popup_menu' localization within htmlField
# 2005-06-10 changed lng() and -lng, new lngslot(), lnghash()
# 2005-06-07 cgiQuery: $qo ||'-aeq'
# 2005-06-07 new -env
# 2005-06-07 lnglbl: htmlMChs
# 2005-06-06 lnglbl: tfdRFD tvmVersions tvmHistory tvmReferences tvdIndex tvdFTQuery
# 2005-06-05 lnglbl() & lngsmt(), for htmlMenu, cgiForm, cgiList
# 2005-06-03 hash item variants for -frmLso and -frmLsc
# 2005-05-31 new -frmLsc
# 2005-05-30 cgiForm field list obtain order changed; use of -mdefld
# 2005-05-30 dbiSel field descriptions obtain using -mdefld
# 2005-05-29 new -racUser
# 2005-05-27 partitioned -frmLso
# 2005-05-24 datastr/strdata changing
# 2005-05-24 new -frmLsoAdd
# 2005-05-16 new urlOpt
# 2005-05-16 new -frmLso2C
# 2005-05-14 changed htmlMenu, cgiQuery
# 2005-05-14 new -frmLso0A, -frmLso0C, -frmLso1C
# 2005-05-04 uglist(user|group)
# 2005-05-03 new -userln, -usernt
# 2005-05-02 cgibus default usergroups implementation
# 2005-05-02 local -pcmd, -pdta, -pout to consider within triggers
# 2005-05-02 reordered -recForm0C to run after command-specific trigger
# 2005-05-02 new -recChg0A, -recChg1A, removed -recForm0A, -recForm1A
# 2005-05-01 new 'recLast', problem '-recForm0A'
# 2005-04-29 new -recForm1A
# 2005-04-28 renamed -recNew0R -> -recNew0C
# 2005-04-28 removed -recRead0R, -recRead1R, -recIns0C, -recIns1C, -recTrim0C
# 2005-04-28 new -recTrim0A, -recForm0A
# 2005-04-27 renamed -recJoint1R -> -recForm1C
# 2005-04-27 renamed -recForm1R -> -recForm0C
# 2005-04-26 development -recTrim0C
# 2005-04-24 examples settings commented
# 2005-04-24 dbiLsLike -> dbiACLike, new -dbiACLike slot.
# 2005-04-21 dbiLsLike filter sub{} // field list should be good
# 2005-04-16 htmlMenu for Mozilla
# 2005-04-16 dbiLsLike postgresql rlike
# 2005-04-10 cgiQuery -frmLso: developments & corrections
# 2005-04-10 cgiQuery -frmLso: -rvcFinState, -rvcAllState
# 2005-04-09 datastr correction
# 2005-04-09 some cgiQuery -frmLso and -qfrmLso development
# 2005-04-09 principal(s) excluding actor(s)
# 2005-04-08 htmlRFD correction, -fupd record attr
# 2005-04-08 sub{} as -frmLso
# 2005-04-05 -qwhere default query condition
# 2005-04-05 check-out '-frmLso' options
# 2005-04-04 development of '-frmLso' and 'mdeRole'.
# 2005-04-03 -frmLso field and option replaces -qurole field and switch
# 2005-03-31 gwo -racPrincipal, -racActor
# 2005-03-30 qurole language strings, -qurole table switch.
# 2005-03-30 lng improvement.
# 2005-03-28 htmlML: window.document.open
# 2005-03-27 'uadmin' -renamed-> 'uadmwtr'
# 2005-03-26 'udisp' with 'cgiForm'
# 2005-03-25 debug 'dbiLsLike'
# 2005-03-24 fields hyperlinking with '-ddlb' or '-form'
# 2005-03-22 '-version' meanings/use case; deletion check-in; recDel triggers
# 2005-03-17 again 'recUpd', checkouts
# 2005-03-15 some debug
# 2005-03-14 rename '-rvcFinState' -> '-rvcChgState'
# 2005-03-12 '-rvcFinState' / mkdir 'c:/srv/apache/htdocs/cgi-bus/gwo/ver/olmikh_2F/2003/02/06/09/5131$';
# 2005-03-11 cgiParse '-key' -> '-qkey' translation for 'recList'
# 2005-03-10 field cell html properties: -lhprop, -ldprop, -fhprop, -fdprop
# 2005-03-09 dbi placeholders dialect flag '-dbiph'
# 2005-03-08 using mdeQuote() for quoting field values
# 2005-03-07 mdeTable() new '-mdefld' slot
# 2005-03-06 tfvVersions() sql branch improved
# 2005-03-06 cgiList() defaults inheritance from form or table
# 2005-03-02 'cgiList' rewritten, -display query clause,...
# 2005-03-03 inheriting field '-null' from form or table
# 2005-02-26 field class/styles: -lhclass, -lhstyle, -ldclass, -ldstyle, -fdclass, -fdstyle, -fhclass, -fhstyle
# 2005-02-22 ui new -qkeyord option
# 2005-02-22 dbm -keyqn option implemented
# 2005-02-21 sql -keyqn option implemented: undef and '' treat the same in '-key'
# 2005-02-19 sql data engine testing
# 2005-02-19 sql insert, update, delete, select redesigned to embed values in statements
# 2005-02-03 '-cgibus' compatibillity option
# 2005-01-27 '-expr' for tables
# 2005-01-24 redesign of form layout hints; new '</table>' hint
# 2005-01-23 '-refresh' option
# 2005-01-23 form focusing
# 2005-01-23 ddlb default selection, doubleclick, search prompt and field
# 2005-01-22 sql experiments
# 2005-01-07 ugroups(?user) variant in addition to ugnames(?user)
# 2005-01-07 xml 'encoding' corrected
# 2005-01-07 styles without '_', for page or each special tag
# 2004-10-17 joined label+widget sub{} not needed because of free-form layout possible
# 2004-10-17 'htmlField' - improved cgi attributes processing
# 2004-10-13 '-urm' introduced.
# 2004-10-10 check naming unification of lng messages, images, commands.
# 2004-10-09 '-udflt' slot to filter domains in 'w32agf'
# 2004-10-09 redesign of 'Default Data Definitions' to 'Templates' routines.
# 2004-09-21 '-unflt' and '-ugflt' slots to filter user and group names.
# 2004-09-14 '-racAdmRdr' slot added.
# 2004-09-14 '-racAdmWtr' can read only permitted records, but update all can read.
# 2004-09-14 edit mode switched off when record save.
# 2004-09-14 new 'w32user', 'w32udisp'.
# 2004-09-13 'w32ugrps' added for optional usage, good legacy example.
# 2004-09-13 'w32agf' rewrite with 'ugroups' and 'uglist', using ADSI
# 2004-09-13 '-end0', '-endh', '-end1' slots
# 2004-08-31 dhtml for bottom screen messages
# 2004-08-15 file attachments UNC path displayed to copy
# 2004-08-15 MSHTML Control
# 2004-06-26 review '!!!' (categorization, primary todos implementation)
# 2004-06-23 default query conditions display
# 2004-06-23 temporary files environment variables redesigned
# 2004-06-22 using 'DHTML Editing Component'
# 2004-06-21 'dbmSeek' string condition parser improved
# 2004-06-21 XML record lists
# 2004-06-19 XML record form
# 2004-06-18 menu listboxes behaviour improved
# 2004-06-13 log file more readable
#		+ input / operation / rezult	- operation only
#		+ '-name'=>value forms
#		+ quoting and terminating SQL
# 2004-06-11 full-text search in file attachments
# 2004-06-08 corrected 'nfopens', 'nfclose', 'w32domain'
# 2004-06-06 'ddvIndex'; 'logRec' analisys
# 2004-06-01 ui: html styles - using classes
# 2004-05-15 '-urole' & '-uname' query keywords
# 2004-03-16 paused
# 2004-03-12 table factory triggers and documentation
# 2004-03-03 ui: printable html
# 2004-02-29 'mdeTable', 'mdlTable': table factory base
# 2004-02-27 not needed: restrict 'recIns' and 'recUpd' values to described '-field's?
# 2004-02-27 '-keyord' & '-filter': query conditions unification: order option, key, joint, filter codeblock, while codeblock
# 2004-02-26 'ns' naming set
# 2004-02-22 default indexes (versions, news, references,...) review
# 2004-02-17 table/ID rec IDs in 'History' view
# 2004-02-17 embedded versions view definition
# 2004-02-08 'setup' sub, '-setup' & '-reindex' command line options.
# 2004-02-06 drop file sessions to attachments: 'nfopens', 'nfclose', 'htmlRFD'
# 2004-02-03 problem documented: optimizing dbm cursor looping in 'rec'/'dbi' code
# 2004-02-02 necessary: duplicate fields&valies copying in 'recXXX' for triggers and in 'dbiXXX' for SQL or cleanup special fields for dbi
# 2004-02-01 optional html convertors of fields 'cgiList'ed - 'lsthtml'
# 2004-01-29 documentation spell and check
# 2004-01-26 document size analisys
# 2004-01-25 document concepts
# 2004-01-11 'cgiParse':  '-key' split into table/form and rec ID, if needed
# 2004-01-10 'recNew' all field values inheritance problem: -recNew0R trigger should inherit
# 2004-01-09 dbm -key search interpretation, -order options metastructure
# 2004-01-09 dbm -where search condition interpretation
# 2004-01-06 indexing trigger '-recIndex0R'
# 2004-01-04 record form is alike table in 'recType' and 'rmiTrigger'.
# 2004-01-04 reformed '-joint' idea to '-recJoint1R' trigger and '-qfilter' sub{}
# 2004-01-03 file attachments database API
# 2003-12-28 CGI user interface initial implementation
# 2003-12-28 perl script pages implemented
# 2003-12-27 documentation started
# 2003-12-25 record ID splitting problem: $RISM[012], -idsplit, -recInsID, -rfdName
# 2003-12-21 user authentication
# 2003-12-21 message constants
# 2003-12-18 user group file usage; also generation in windows
# 2003-12-15 'w32IISdpsn' to escape IIS impersonation
# 2003-12-14 acls (see '!!!' about 'LIKE')
# 2003-12-14 attachments acls
# 2003-12-07 '-joint' codeblock problem resolved by incapsulated hash ref binding
# 2003-12-07 incapsulated hash ref binding
# 2003-11-19 implement '-affect' db interface
# 2003-11-18 generate alphanumeric incremental record IDs instead long numeric
# 2003-11-17 cgiDDLB
# 2003-11-10 form vs table problem - 'recRead' loads record only, not join, '-read' option like '-query'
# 2003-11-09 sql full-text search
# 2003-11-09 consider old versions in 'dbiUpd'
# 2003-11-08 version display switching for 'recSel'/'dbiSel'/'cgiXXX'
# 2003-11-07 cgi file attachments
# 2003-11-02 commit/rollback/finish
# 2003-10-11 first cgi script for testing
# 2003-10-07 begin of smallest database API testing
# 2003-09-16 started
#


package DBIx::Web;
require 5.000;
use strict;
use UNIVERSAL;
use POSIX;
use Fcntl qw(:DEFAULT :flock :seek :mode);

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $AUTOLOAD $SELF $CACHE $LNG $IMG);

	$VERSION= '0.58';
	$SELF   =undef;				# current object pointer
	$CACHE	={};				# cache for pointers to subobjects
	*isa    = \&UNIVERSAL::isa; isa('','');	# isa function

my	$RISM0  ='/';		# record identification separation mark 0
my	$RISM1	='//';		# record identification table/id seperator 
				# (-idsplit; consider -recInsID, -rfdName)
my	$RISM2  ='.rfd';	# record identification end   special mark 
my	$NLEN	=14;		# length to pad left numbers in indexes
my	$LIMRS	=512;		# limit of result set
my	$KSORD	='-aall';	# default key sequental order
my	$HS	=';';		# hyperlink parameters separation style '&'


	# see also '-tn' definitions

if	($ENV{MOD_PERL}) { # $ENV{GATEWAY_INTERFACE} && $ENV{GATEWAY_INTERFACE} =~/^CGI-Perl\//
	eval('use Apache qw(exit);');
}

$LNG ={
''	=>{''		=>['',		'']
	,-lang		=>['en',	'']
	,-charset	=>['windows-1252','']

	,-style		=>['Style'	,'HTML/XML style decoration URL']
	,-affected	=>['affected',	'rows affected']
	,-fetched	=>['fetched',	'rows fetched']
	,'rfaUplEmpty'	=>['empty',	'Empty filehandle']
	,'recUpdAclStp'	=>['',		'Record updation prohibited to you']
	,'recUpdVerStp'	=>['',		'Editing record\'s version prohibited']
	,'recDelAclStp'	=>['',		'Record deletion prohibited to you']
	,'recReadAclStp'=>['',		'Record reading prohibited to you']

	,'back'		=>['<',		'Back screen']
	,'login'	=>['Login',	'Login as personated user']
	,'frmCall'	=>['Go',	'Goto/execute choise']
	,'frmCallOpn'	=>['Open']
	,'frmCallNew'	=>['Create for','Create new record to insert into']
	,'frmName'	=>['Form',	'Form name to choose']
	,'frmLso'	=>['Query',	'Specify records to be listed']
	,'frmName1'	=>['Create',	'Create new record with form choosen to insert into database']
	,'recNew'	=>['Create',	'Create new record to insert into database']
	,'recRead'	=>['Read',	'Read record from the database; escape edit mode discarding changes']
	,'recEdit'	=>['Edit',	'Edit this data to update in the database']
	,'recPrint'	=>['Print',	'Printable form']
	,'recXML'	=>['XML',	'XML form']
	,'recIns'	=>['Insert',	'Insert this data into database as a new record']
	,'recUpd'	=>['Save',	'Update this record or save data into database']
	,'recDel'	=>['Delete',	'Delete this record in the database']
	,'recForm'	=>['Form',	'Recheck this data on server']
	,'recList'	=>['List',	'List records, execute query']
	,'recQBF'	=>['Query',	'Specify records to be listed']

	,'-qkeyord'	=>['SEEK',	'Key seek relation']
	,'-qwhere'	=>['WHERE',	'WHERE database query clause']
	,'-qurole'	=>['UROLE',	'Role of User']
	,'-quname'	=>['UNAME',	'Name of User']
	,'-qftext'	=>['FULL TEXT',	'Full-text search string']
	,'-qversion'	=>['VERSIONS',	'Including old versions of records']
	,'-qorder'	=>['ORDER BY',	'ORDER BY database query clause']
	,'-qlimit'	=>['LIMIT',	'LIMIT database query clause']

	,'rfafolder'	=>['Files',	'File Attachments']
	,'rfauplfld'	=>['Upload',	'File to upload']
	,'rfaupdate'	=>['+/ -',	'Upload file, close or delete attachments selected']
	,'rfaopen'	=>['...',	'Opened file attachments to be closed']
	,'rfaclose'	=>['Close']
	,'rfadelm'	=>['Delete',	'Mark file attachments to be deleted']

	,'ddlbopen'	=>['...',	'Open values']
	,'ddlbsubmit'	=>['Set',	'Assign value selected']
	,'ddlbclose'	=>['x',		'Close values']
	,'ddlbfind'	=>['..',	'Find value in the list']

	,'tvmVersions'	=>['All Versions',	'All records and their versions']
	,'tvmHistory'	=>['All News',		'All news, updates, deletions']
	,'tvmReferences'=>['All References',	'All references to records']
	,'tvdIndex'	=>['All Contents',	'Table of contents']
	,'tvdFTQuery'	=>['All Files Find',	'Full-text query on files']
	,'-qftwhere'	=>['FTQuery',	'Full-text query condition']
	,'-qftord'	=>['FTOrder',	'Full-text search result set sort order']
	,'-qftlimit'	=>['FTLimit',	'Full-text search result set limit']

	,'table'	=>['Table',	'Table or recfile name']
	,'id'		=>['ID',	'Record ID', 'id']
	,'ir'		=>['IR',	"Refered ID"]
	,'idrm'		=>['AboveID',	"Record, above this, 'id' or 'table'//'id'"]
	,'idpr'		=>['PrevID',	"Record, previous to this, 'id' or 'table'//'id'"]
		,'hierarchy'	=>['hierarchy']
	,'cuser'	=>['Ins by',	'User, record inserted by']
	,'creator'	=>['Ins by',	'User, record inserted by']
	,'ctime'	=>['Ins time',	'Date and time, record inserted when']
	,'uuser'	=>['Upd by',	'User, record updated by']
	,'updater'	=>['Upd by',	'User, record updated by']
	,'utime'	=>['Upd time',	'Date and time, record updated when']
	,'idnv'		=>['Ver of',	'Actual record ID, points to the actual and fresh version']
	,'status'	=>['State',	'State of the record']
		,'todo'		=>['todo']
		,'done'		=>['done']
		,'deleted'	=>['deleted']
		,'edit'		=>['edit']
		,'all'		=>['all']
	,'auser'	=>['Actor',	'Actor of the record, user name']
	,'actor'	=>['Actor',	'Actor of the record, user name']
	,'arole'	=>['Actors',	'Role of actor of the record or additional actor']
	,'actors'	=>['Actors',	'Actors of record, users and groups, comma delimited']
	,'puser'	=>['Principal',	'Principal of record, user name']
	,'principal'	=>['Principal',	'Principal of record, user name']
	,'prole'	=>['Principals','Role of principal of the record or additional principal']
	,'principals'	=>['Principals','Principals of record, users and groups, comma delimited']
	,'user'		=>['User',	'User of record, user name']
	,'users'	=>['Users',	'Users of record, users and groups, comma delimited']
	,'author'	=>['Author',	'Author of the record, user name']
	,'authors'	=>['Authors',	'Authors of the record, comma delimited']
	,'rrole'	=>['Readers',	'Readers of the record, group or role']
	,'readers'	=>['Readers',	'Readers of the record, users and groups, comma delimited']
	,'record'	=>['Record',	'Class/type of the record described by']
	,'object'	=>['Object',	'Object of the record described by']
	,'project'	=>['Project',	'Project, related to the record']
	,'subject'	=>['Subject',	'Subject, Title, Brief description']
	,'comment'	=>['Comment',	"Comment text or HTML, 'urlh://', 'urlr://', 'urlf://' URL protocols may be used to denote relative URLs to host, this script, file store"]
	,'cargo'	=>['Cargo',	'Additional data']
	}
,'ru'	=>{''		=>['',		'']
	,-lang		=>['ru-RU',	'']
	,-charset	=>['windows-1251','']

	,-style		=>['Стиль'	,'Гиперссылка стилевой декорации HTML/XML']
	,-affected	=>['затронуто',	'строк затронуто']
	,-fetched	=>['выбрано',	'строк выбрано']
	,'rfaUplEmpty'	=>['пусто',	'Пустой манипулятор файла']
	,'recUpdAclStp'	=>['',		'Изменение записи не разрешено полномочиями доступа пользователя']
	,'recUpdVerStp'	=>['',		'Изменение прежней версии записи запрещено']
	,'recDelAclStp'	=>['',		'Удаление записи не разрешено полномочиями доступа пользователя']
	,'recReadAclStp'=>['',		'Чтение записи не разрешено полномочиями доступа пользователя']

	,'back'		=>['<',		'Предыдущая страница']
	,'login'	=>['Войти',	'Открыть персонифицированный сеанс']
	,'frmCall'	=>['Вып',	'Выполнить переход, действие, поиск']
	,'frmCallOpn'	=>['Открыть']
	,'frmCallNew'	=>['Создать в',	'Создать новую запись, чтобы затем вставить ее в']
	,'frmName'	=>['Форма',	'Выбрать форму']
	,'frmLso'	=>['Выборка',	'Выбрать просматриваемые записи']
	,'frmName1'	=>['Создать',	'Создать новую запись выбранной формы, чтобы затем вставить ее в базу данных']
	,'recNew'	=>['Создать',	'Создать новую запись, чтобы затем вставить ее в базу данных']
	,'recRead'	=>['Читать',	'(Пере)читать запись из базы данных; перейти от редактирования записи к просмотру с потерей результатов редактирования']
	,'recEdit'	=>['Править',	'Начать редактирование (изменение) записи']
	,'recPrint'	=>['Печать',	'Представление для печатания']
	,'recXML'	=>['XML',	'Представление XML']
	,'recIns'	=>['Вставить',	'Добавить результаты редактирования в базу данных как новую запись']
	,'recUpd'	=>['Сохранить',	'Сохранить результаты редактирования (изменения) записи в базе данных']
	,'recDel'	=>['Удалить',	'Удалить эту запись из базы данных']
	,'recForm'	=>['Форм',	'Перезагрузить форму с сервера, перевычислить данные']
	,'recList'	=>['Выбрать',	'(Пере)читать представление, выбрать записи согласно условию выборки (поиска)']
	,'recQBF'	=>['Запрос',	'Задание условия выборки (поиска) записей']

	,'-qkeyord'	=>['SEEK',	'Направление поиска по ключу']
	,'-qwhere'	=>['WHERE',	'Конструкция запроса WHERE']
	,'-qurole'	=>['UROLE',	'Роль пользователя']
	,'-quname'	=>['UNAME',	'Имя пользователя']
	,'-qftext'	=>['FULL TEXT',	'Строка полнотекстового поиска']
	,'-qversion'	=>['VERSIONS',	'Включение прежних версий записей']
	,'-qorder'	=>['ORDER BY',	'Конструкция запроса ORDER BY']
	,'-qlimit'	=>['LIMIT',	'Конструкция запроса LIMIT']

	,'rfafolder'	=>['Файлы',	'Присоединенные файлы']
	,'rfauplfld'	=>['Загрузить',	'Файл для загрузки']
	,'rfaupdate'	=>['+/ -',	'Загрузить файл, закрыть или удалить выбранные присоединения файлов']
	,'rfaopen'	=>['...',	'Открытые присоединенные файлы, которые можно закрыть']
	,'rfaclose'	=>['Закрыть']
	,'rfadelm'	=>['Удалить',	'Пометить присоединения файлов для удаления']

	,'ddlbopen'	=>['...',	'Открыть список значений']
	,'ddlbsubmit'	=>['Присв.',	'Присвоить выбранное значение']
	,'ddlbclose'	=>['x',		'Закрыть список значений']
	,'ddlbfind'	=>['..',	'Найти значение в списке']

	,'tvmVersions'	=>['Все Версии',	'Все записи и их версии']
	,'tvmHistory'	=>['Все Новости',	'Все новые, измененные, удаленные записи']
	,'tvmReferences'=>['Все Ссылки',	'Все ссылки на записи']
	,'tvdIndex'	=>['Все Оглавление',	'Содержание']
	,'tvdFTQuery'	=>['Поиск файлов',	'Полнотекстовый поиск в файлах']
	,'-qftwhere'	=>['FTQuery',		'Условие полнотекстового поиска']
	,'-qftord'	=>['FTOrder',		'Сортировка результатов полнотекстового поиска']
	,'-qftlimit'	=>['FTLimit',		'Ограничение численности результатов полнотекстового поиска']

	,'table'	=>['Таблица',	'Имя таблицы или файла записей']
	,'id'		=>['ID',	'Идентификатор записи', 'id']
	,'ir'		=>['Ссылка',	"Ссылка на идентификатор записи"]
	,'idrm'		=>['Главная',	"Идентификатор вышестоящей записи, 'id' либо 'table'//'id'"]
	,'idpr'		=>['Предш',	"Идентификатор предшествующей записи, 'id' либо 'table'//'id'"]
		,'hierarchy'	=>['иерархия']
	,'cuser'	=>['Создал',	'Кем была создана запись']
	,'creator'	=>['Создал',	'Кем была создана запись']
	,'ctime'	=>['Созд-е',	'Когда запись была создана']
	,'uuser'	=>['Изменил',	'Кем была последний раз изменена запись']
	,'updater'	=>['Изменил',	'Кем была последний раз изменена запись']
	,'utime'	=>['Измен-е',	'Когда последний раз была изменена запись']
	,'idnv'		=>['Бывш',	'Идентификатор актуальной записи, указывает на актуальную (последнюю) версию']
	,'status'	=>['Статус',	'Статус записи, состояние или результат деятельности']
		,'todo'		=>['сделать']
		,'done'		=>['завершено']
		,'deleted'	=>['удалено']
		,'edit'		=>['редакт-е']
		,'all'		=>['все']
	,'auser'	=>['Исп-ль',	'Исполнитель записи, пользователь']
	,'actor'	=>['Исп-ль',	'Исполнитель записи, пользователь']
	,'arole'	=>['Исп-ли',	'Роль или группа исполнителя записи, либо добавочный исполнитель']
	,'actors'	=>['Исп-ли',	'Исполнители записи, пользователи и группы, через запятую']
	,'puser'	=>['Иниц-р',	'Инициатор записи, пользователь']
	,'principal'	=>['Иниц-р',	'Инициатор записи, пользователь']
	,'prole'	=>['Иниц-ры',	'Роль или группа инициатора записи, либо добавочный инициатор']
	,'principals'	=>['Иниц-ры',	'Инициаторы записи, пользователи и группы, через запятую']
	,'user'		=>['Польз',	'Пользователь записи']
	,'users'	=>['Польз-ли',	'Пользователи записи, пользователи и группы, через запятую']
	,'author'	=>['Автор',	'Автор записи, пользователь']
	,'authors'	=>['Авторы',	'Авторы записи, пользователи и группы, через запятую']
	,'rrole'	=>['Читатели',	'Роль или группа читателей записи']
	,'readers'	=>['Читатели',	'Читатели записи, пользователи и группы, через запятую']
	,'record'	=>['Запись',	'Класс или тип записей']
	,'object'	=>['Объект',	'Объект или ключевое слово, к которому относится запись']
	,'project'	=>['Проект',	'Направление, объект, процесс, статья расходов, к которой относится запись']
	,'subject'	=>['Тема',	'Тема или заглавие записи']
	,'comment'	=>['Коммент',	"Текст или HTML комментария, гиперссылки могут быть начаты с 'urlh://' (компьютер), 'urlr://' (этот сценарий), 'urlf://' (файловое хранилище)"]
	,'cargo'	=>['Карго',	'Дополнительные данные']
	}
};


$IMG={
	 'back'		=>'back.gif'
	,'login'	=>'small/key.gif'
	,'frmCall'	=>'hand.up.gif' # hand.up continued left transfer folder.open
	,'recNew'	=>'generic.gif'
	,'recRead'	=>'up.gif'
	,'recEdit'	=>'quill.gif'
	,'recPrint'	=>'p.gif'
	,'recXML'	=>'script.gif'
	,'recIns'	=>'burst.gif'
	,'recUpd'	=>'down.gif'
	,'recDel'	=>'broken.gif'
	,'recForm'	=>'forward.gif'
	,'recList'	=>'text.gif'
	,'recQBF'	=>'index.gif'
	,'rfafolder'	=>'folder.open.gif'
};

1;



#######################


sub new {
 my $c=shift;
 my $s ={};
 bless $s,$c;
 $s =$s->initialize(@_);
}



sub initialize {
 my $s   =shift;
 my %opt =@_;
 $CACHE->{$s} ={};
 $s->set(-env=>$opt{-env})	if $opt{-env};

 %$s =(
 #  -env	=>undef		# Environment variables setup
    -title	=>''		# Application's title
 # ,-locale	=>''		# Application's locale
 # ,-lang	=>undef		# Application's language
 # ,-charset	=>undef		# Application's charset
 # ,-lng	=>''		# User's language
 # ,-lnglbl	=>''		# -lbl key
 # ,-lngcmt	=>''		# -cmt key

   ,-debug      =>0		# Debug Mode
   ,-die        =>\&CORE::die	# die  / croak / confess: &{$s->{-die} }('error')
   ,-warn       =>\&CORE::warn	# warn / carp  / cluck  : &{$s->{-warn}}('warning')
 # ,-end0	=>undef		# 'end' before trigger
   ,-endh	=>{}		# 'end' before hash
 # ,-end1	=>undef		# 'end' after  trigger

 # ,-var        =>undef		# Variables {}, see varLoad, varStore
   ,-log        =>1		# Log file switch/handle, see logOpen
   ,-logm	=>100		# Log list max size

   ,-c => {			# Cache for computed values
        # ,-pth_tmp	=>undef	# Temporary files path, see pthForm('tmp')
        # ,-pth_var	=>undef	# Variable  files path, see pthForm('var')
        # ,-pth_log	=>undef	# Log       files path, see pthForm('log')
	# ,-logm	=>[]	# Log list
        # ,-user	=>undef	# User Name
        # ,-unames	=>[]	# User Names
        # ,-ugroups	=>[]	# User Groups
          }

 # ,-path       =>'./dbix-web'	# Path to file store, default below
 # ,-url        =>'/dbix-web'	# URL  to file store, default below
 # ,-urf        =>'file://./dbix-web'# Filesystem URL to file store, default below
                  

   ,-host	=>undef		# Host  Name, default below
 # ,-dbi	=>undef		# DBI object, if used
 # ,-dbiarg	=>undef		# DBI connection arguments string or array
 # ,-dbiph	=>undef		# DBI placeholders ('?') dialect switch
 # ,-dbiACLike	=>undef		# DBI ACL LIKE options: rlike regexp,...
 # ,-cgi	=>undef		# CGI object
   ,-serial	=>1		# Serialised: 1 - updates, 2 - updates & reads, 3 - reads
   ,-keyqn	=>1		# query key ''/undef compatibility
 # ,-output	=>undef		# output sub{} instead of 'print'

   ,-table	=>{}		# database files
				# -field=>{name=>{}}
				# -key	=>[field]
				# -keycmp=>sub{}	# key compare dbm sub{}
				# -ixcnd=>sub{}||1	# index condition
				# -ixrec=>sub{}		# form index record
				# -optrec		# optional records
				# -dbd =>'dbi'|'dbm'	# database store
				# -recXXX		# trigger or implementation

				# -subst		# substitute another
				# -cgcXXX=>''|sub{}	# cgi call implementation
				# -cgvXXX=>''|sub{}	# cgi call presentation

				# -frmLso		# form query option
				# -query		# query condition hash
				# -qfilter		# filters rows fetched
				# -qhref		# query hyperlink hash or sub{}
				# -qhrcol		# q h left columns
				# -qflghtml		# !empty flag when '!h'
				# -qfetch		# query fetch sub{}
				# -limit		# query limit rows

				# -recRead		# recRead condition hash

 # ,-user	=>undef		# User Name   sub{} or value, default below
   ,-userln	=>1		# User local  short names switch
   ,-usernt	=>0		# User syntax alike WinNT
 # ,-unames	=>[]		# User Names  sub{} or value
 # ,-ugroups	=>[]		# User Groups sub{} or value
 # ,-udflt	=>sub{}		# User Domains	filter
 # ,-unflt	=>sub{}		# User Names	filter
 # ,-ugflt	=>sub{}		# User Groups	filter
 # ,-AuthUserFile		# Apache Users  file, optional
 # ,-AuthGroupFile		# Apache Groups file, optional
 # ,-fswtr	=>undef		# File Store Writers, default below
 # ,-fsrdr	=>undef		# File Store Readers

 # ,&recXXX			# DML command keywords
					# -table -form || record form class
					# -from
					# -data
					# -key -where 
					# -urole -uname
					# -filter -limit
					# -order -keyord -group
					# -save -optrec -test
					# -new -file -fupd -editable # record attributes

				# Record Manipulation Options:
 # ,-dbd	=>undef		# default database engine
   ,-autocommit =>1		# autocommit database mode
 # ,-limit	=>undef||number	# limit of selection
 # ,-affect	=>undef||1	# rows number to affect by DML
 # ,-affected			# rows number affected	by DML
 # ,-fetched			# rows number fetched	by DBL
 # ,-limited			# rows number limited	by DBL
 # ,-index	=>boolean	# include materialized views support
   ,-idsplit	=>1 		# split complex rec ID to table and row ID: 0 || sub{}

				# Record Access Control rooles:
   ,-rac	=>1		# switch on
   ,-racAdmWtr	=>'Administrators,root'
   ,-racAdmRdr	=>'Administrators,root'
 # ,-racReader	=>[fieldnames]	# readers fieldnames
 # ,-racWriter	=>[fieldnames]	# writers fieldnames

				# Record Version Control rooles:
 # ,-rvcInsBy	=>'fieldname'	# field for user name	record inserted	by
 # ,-rvcInsWhen	=>'fieldname'	# field for time	record inserted	when
 # ,-rvcUpdBy	=>'fieldname'	# field for user name	record updated	by
 # ,-rvcUpdWhen	=>'fieldname'	# field for time	record updated	when
 # ,-rvcActPtr	=>'fieldname'	# field for actual record version pointer
 # ,-rvcChgState=>[fld=>states]	# changeble states of record
 # ,-rvcCkoState=>[fld=>state ]	# check-out state  of record
 # ,-rvcDelState=>[fld=>state ]	# deleted   state  of record

				# Record File Attachments rooles:
   ,-rfa	=>1		# switch on
 # ,-rfdName	=>sub{}		# 'rfdName'  formula for key processing

                                # Record ID References
 # ,-ridRef	=>[]		# reference fields

				# Record Manipulation Triggers:
 # ,-recTrim0A	=>sub{}		# 'recTrim' trigger before	UI action
 # ,-recChg0A	=>sub{}		# 'recChg'  trigger before	UI action
 # ,-recChg1A	=>sub{}		# 'recChg'  trigger after	UI action
 # ,-recNew	=>'form'|sub{}	# 'recNew'  UI implementation
 # ,-recNew0C	=>sub{}		# 'recNew'  trigger before	each row
 # ,-recNew1C	=>sub{}		# 'recNew'  trigger after	command
 # ,-recForm	=>'form'|sub{}	# 'recForm' UI implementation
 # ,-recForm0C	=>sub{}		# 'recForm' trigger before	command
 # ,-recForm1C	=>sub{}		# 'recForm' trigger after	command
 # ,-recIns	=>'form'|sub{}	# 'recIns'  UI implementation
 # ,-recIns0C	=>sub{}		# 'recIns'  trigger before	row command
 # ,-recIns0R	=>sub{}		# 'recIns'  trigger before	row
 # ,-recInsID	=>sub{}		# 'recIns'  trigger for key generation
 # ,-recIns1R	=>sub{}		# 'recIns'  trigger after	row
 # ,-recIns1C	=>sub{}		# 'recIns'  trigger after	row command
 # ,-recUpd	=>'form'|sub{}	# 'recUpd'  UI implementation
 # ,-recUpd0C	=>sub{}		# 'recUpd'  trigger before	command
 # ,-recUpd0R	=>sub{}		# 'recUpd'  trigger before	each row
 # ,-recUpd1C	=>sub{}		# 'recUpd'  trigger after	command
 # ,-recDel	=>'form'|sub{}	# 'recDel'  UI implementation
 # ,-recDel0C	=>sub{}		# 'recDel'  trigger before	command
 # ,-recDel0R	=>sub{}		# 'recDel'  trigger before	each row
 # ,-recDel1C	=>sub{}		# 'recDel'  trigger after	command
 # ,-recSel0C	=>sub{}		# 'recSel'  trigger before	command
 # ,-recRead	=>'form'|sub{}	# 'recRead' UI implementation
 # ,-recRead0C	=>sub{}		# 'recRead' trigger before	row command
 # ,-recRead0R	=>sub{}		# 'recRead' trigger before	row command
 # ,-recRead1R	=>sub{}		# 'recRead' trigger after	row command
 # ,-recRead1C	=>sub{}		# 'recRead' trigger after	row command
 # ,-recList	=>'form'|sub{}	# 'recList' UI implementation

   ,-tn		=>{             # Template naming, see also 'ns' sub
	 ''		=>''
	,-guest		=>'guest'	# guest user name
	,-quests	=>'guests'	# guest user group
	,-users		=>'users'	# authenticated user default group
	,-dbd		=>'dbm'		# defaultest data engine

	,-id		=>'id'		# record identifier
	,-key		=>['id']	# record key
	,-rvcInsBy	=>'cuser'	# user, record inserted by
	,-rvcInsWhen	=>'ctime'	# time, record inserted when
	,-rvcUpdBy	=>'uuser'	# user, record updated  by
	,-rvcUpdWhen	=>'utime'	# time, record updated  when
			# 'auser'	# actor user
			# 'arole'	# actor roles
			# 'puser'	# principal user
			# 'prole'	# principal roles
	,-rvcActPtr	=>'idnv'	# id of new version of record
			# 'idrm'	# id of master record
			# 'idrr'	# id of root reference
			# 'idpr'	# id of previous record in cause chain
			# 'idpt'	# point to record
			# 'idlr'	# location record pointer
	,-rvcState	=>'status'	# state of record
	,-rvcAllState	=>['ok','no','do','progress','chk-out','edit','deleted']
	,-rvcFinState	=>['status'=>'ok','no','deleted']
	,-rvcChgState	=>['status'=>'edit','chk-out']
	,-rvcCkoState	=>['status'=>'chk-out']
	,-rvcDelState	=>['status'=>'deleted']
	,'tvmVersions'	=>'versions'	# versions view name
	,'tvmHistory'	=>'history'	# history view name
	,'tvmReferences'=>'references'	# references view name
	,'tvdIndex'	=>'index'	# index view name
	,'tvdFTQuery'	=>'fulltext'	# full-text view name
   }
				# CGI server user interface
 # ,-httpheader =>{}
 # ,-htmlstart  =>{}
   ,-icons	=>'/icons'	# Icons URL
 # ,-logo	=>''		# Logotype to display
   ,-login	=>'/cgi-bin/ntlm/'# Login URL
 # ,-menuchs	=>[[]]
 # ,-menuchs1	=>[[]]
 # ,-form	=>{}		# user interface forms, see '-table'
 # ,-pcmd	=>{}		# command input parameters
 # ,-pdta	=>{}		# data input
 # ,-pout	=>{}		# parameters output (cursor)
   );

 if (!$opt{-path}) {
	my $pth =$^O eq 'MSWin32' ? Win32::GetFullPathName($0) : $0;
	$pth =  $ENV{DOCUMENT_ROOT}
		? $ENV{DOCUMENT_ROOT} .'/'
		: $pth =~/^(.+?[\\\/]wwwroot[\\\/])/i
		? $1
		: $pth =~/^(.+?[\\\/]inetpub[\\\/])/i
		? $1
	 	: $pth =~/^(.+?[\\\/])cgi-bin[\\\/]/i && -d ($1 .'htdocs')
		? $1 .'htdocs/'
		: $pth =~/^(.+?[\\\/]apache[\\\/])/i && -d ($1 .'htdocs')
		? $1 .'htdocs/'
		: $pth =~/^(.+[\\\/])[^\\\/]*$/
		? $1
		: -d '../htdocs'
		? '../htdocs/'
		: -d '../wwwroot'
		? '../wwwroot/'
		: './';
	$s->set(-path=>$pth .'dbix-web');
 }
 $s->set(-url=>$opt{-cgibus} ? '/cgi-bus' : '/dbix-web')
	if !$opt{-url};

 $s->set(@_);

 $s->set(-locale=>POSIX::setlocale(&POSIX::LC_CTYPE()))
	if !$s->{-locale};
 $s->set(-die=>($ENV{GATEWAY_INTERFACE}||'') =~/CGI/ ? 'CGI::Carp qw(fatalsToBrowser warningsToBrowser)' : 'Carp')
	if !$opt{-die};
 $s->set(-host=>
	($ENV{COMPUTERNAME}||$ENV{HOSTNAME}||eval('use Sys::Hostname;hostname')||'localhost') 
	=~/^([\d.]+|[\w\d_]+)/ ? $1 : 'unknown'
	)
	if !$s->{-host};
 $s->set(-user=>sub{$ENV{REMOTE_USER}||$ENV{USERNAME}||$s->{-tn}->{-guest}})
	if !$s->{-user};
 $s->set(-fswtr=>$ENV{USERNAME} || $^O eq 'MSWin32' ? eval{Win32::LoginName} : `logname`) 
	&& (chomp($s->{-fswtr})||1)
	&& ($s->{-fswtr} =[$s->{-fswtr}])
	if !$s->{-fswtr};
 $s->set(-recTrim0A=>sub{ # $self, {command}, {data}
		foreach my $k (keys %{$_[2]}) {
			next if !defined($_[2]->{$k});
			if ($_[2]->{$k} =~/^\s+/) {$_[2]->{$k} =$'}
			if ($_[2]->{$k} =~/\s+$/) {$_[2]->{$k} =$`}
		}
		$_[2]})
	if !$s->{-recTrim0A};
 $s->set(-recInsID=>sub{
		$_[0]->varLock();
		$_[2]->{'id'} =lc($_[0]->{-host})
		.strpad($_[0],$_[0]->{-var}->{-table}->{$_[1]->{-table}}->{-recInsID}
		=dwnext($_[0],$_[0]->{-var}->{-table}->{$_[1]->{-table}}->{-recInsID}));
		$_[0]->varStore();
		$_[2]->{'id'}})
	if !$s->{-recInsID};
 if ($ENV{MOD_PERL}) {
    Apache->push_handlers("PerlCleanupHandler"
           ,sub{eval{$s->end}; eval('Apache::DECLINED;')});
 }
 $ENV{TMP} =$ENV{TEMP} =$ENV{TMP}||$ENV{tmp}||$ENV{TEMP}||$ENV{temp}
			||$ENV{TMPDIR}		# see CGI.pm source
			||$s->pthForm('tmp');
 $s
}


sub class {
 substr($_[0], 0, index($_[0],'='))
}


sub set {
 return(keys(%{$_[0]})) if scalar(@_) ==1;
 return($_[0]->{$_[1]}) if scalar(@_) ==2;
 my ($s, %opt) =@_;
 foreach my $k (keys(%opt)) {
	$s->{$k} =$opt{$k};
 }
 if ($opt{-env}) {
	my $env =$s->{-env} =ref($opt{-env}) eq 'CODE' ? &{$opt{-env}}(@_) : $opt{-env};
	if (ref($env) eq 'HASH') {
		foreach my $k (keys %$env) {
			if (defined($env->{$k})){$ENV{$k} =$env->{$k}}
			else			{delete($ENV{$k})}
		}
	}
 }
 if ($opt{-die}) {
	my $s =$_[0];
	if    (ref($opt{-die})) {}
	elsif ($opt{-die} =~/^(perl|core)$/i) {
		$s->{-warn} =\&CORE::warn; $s->{-die} =\&CORE::die;
	}
	elsif ($opt{-die}) {
		my $m =($s->{-die} =~/^([^\s]+)\s*/ ? $1 : $s->{-die}) .'::';
		$s->{-warn} =eval('use ' .$s->{-die} .';\\&' .$m .($s->{-debug} ?'cluck'   :'carp' ));
		$s->{-die}  =eval('use ' .$s->{-die} .';\\&' .$m .($s->{-debug} ?'confess' :'croak'));
	}
	$SIG{__DIE__}	=sub{return if $^S; eval{$s->logRec('Die', ($_[0] =~/(.+)[\n\r]+$/ ? $1 : $_[0]))}; eval{$s->recRollback()}};
	$SIG{__WARN__}	=sub{return if $^S; eval{$s->logRec('Warn',($_[0] =~/(.+)[\n\r]+$/ ? $1 : $_[0]))}};
 }
 if (exists $opt{-locale}) {
	$s->{-lng}	='';
	$s->{-lnglbl}	='';
	$s->{-lngcmt}	='';
	$s->{-lang}	=lc($opt{-locale} =~/^(\w\w)/	? $1	: 'en');
	$s->{-charset}	=$opt{-locale} =~/\.(.+)$/	? $1	: '1252';
 }
 if (exists $opt{-lng}) {
	$s->{-lng}	=lc($s->{-lng});
	$s->{-lnglbl}	=$s->{-lng} ? '-lbl' .'_' .$s->{-lng} : '';
	$s->{-lngcmt}	=$s->{-lng} ? '-cmt' .'_' .$s->{-lng} : '';
 }
 if (exists $opt{-autocommit}) {
	$s->{-dbi}->{AutoCommit} =$opt{-autocommit} if $s->{-dbi};
 }
 if ($opt{-cgibus}) {
	$s->{-recInsID} =sub{	# recIns() row ID generation trigger
				# cgi-bus 'gwo.cgi'
		$_[2]->{'id'} =($_[0]->user =~/^([^@]+)@(.+)$/
					? $2 .'\\' .$1
					: $_[0]->user)
				.'/' .$_[0]->strtime('yyyymmddhhmmss')}
		if !$s->{-recInsID};
	$s->{-rfdName} =sub{	# convert record's key into directory name
				# cgi-bus 'gwo.cgi', '-ksplit, tmsql::fsname()
				# 'rfdName()'/'-rfdName'				
			local $_ =$_[1];
			my $r ='';
			while ($_ =~/([\\\/])/) {
				$_ =$';
				my $v =$` .$1; $v =~s/([^a-zA-Z0-9])/uc sprintf("_%02x",ord($1))/eg;
				$r .=$v .'/'
			};
			$r .=join('/'
				,map {	if (defined($_) && $_ ne '') {
						my $v =$_; 
						$v =~s/([^a-zA-Z0-9])/uc sprintf("_%02x",ord($1))/eg;
						$v
					}
					else {return()}
					} substr($_,0,4),substr($_,4,2),substr($_,6,2),substr($_,8,2),substr($_,10));
			$r
		};	
	$RISM2  ='$';		# record identification end   special mark 
				# tmsql	'sub fsname'
				# rmlIdSplit() / -idsplit, cgiForm(), ui...
 }
 if ($opt{-urf} && (substr($opt{-urf},0,1) eq '-')) {
	$s->{-urf}	= $opt{-urf} ne '-path'
			? $s->{$opt{-urf}}
			: $s->{-cgibus}
			?('file://' .$s->{-cgibus})
			:('file://' .$s->{$opt{-urf}})
 }
 $s
}


sub lng {
 my $l =$LNG->{$_[0]->{-lng}} || $LNG->{''};
 my $m;
  @_ <3 
? ($m =$l->{$_[1]} ||$LNG->{''}->{$_[1]}) && ($m->[0] ||$m->[1]) ||$_[1]
: @_ <4
? ( (($m =$l->{$_[2]} ||$l->{'-' .$_[2]}) && $m->[$_[1]])
 || (($m =$LNG->{''}->{$_[2]}	||$LNG->{''}->{'-' .$_[2]})	&& $m->[$_[1]])
 || $_[2])
: eval {my $r =lng(@_[0..2]);
	my $v =!ref($_[3]) ? $_[3] : ref($_[3]) eq 'CODE' ? &{$_[3]}(@_) : strdata($_[0], $_[3]);
	   $v ='undef' if !defined($v);
	$r =~s/\$_/$v/ge ? $r : "$r $v"
	}
}


sub lnghash {	# locale hash (self, index, array)
 return $_[2] 
	? { map {($_, lng($_[0],$_[1],$_))
		} ref($_[2]) eq 'ARRAY' ? @{$_[2]} : ()}
	: ($LNG->{$_[0]->{-lng}} || $LNG->{''})
}


sub lngslot {	# localised slot (self, object, keyname)
 $_[1]->{$_[2] .'_' .$_[0]->{-lng}} || $_[1]->{$_[2]}
}


sub lnglbl {	# localised label (self, object,...)
 foreach my $e (@_[1..$#_]) {
	next if !ref($e);
	my $v =$e->{$_[0]->{-lnglbl}} || $e->{-lbl};
	next if !$v;
	return(ref($v) ? &$v(@_) : $v)
 }
 !ref($_[$#_]) && $_[1]->{$_[$#_]} ? lng($_[0],0,$_[1]->{$_[$#_]}) : ''
}


sub lngcmt {	# localised comment (self, object,...)
 foreach my $e (@_[1..$#_]) {
	next if !ref($e);
	my $v =$e->{$_[0]->{-lngcmt}} || $e->{-cmt} || $e->{$_[0]->{-lnglbl}} || $e->{-lbl};
	next if !$v;
	return(ref($v) ? &$v(@_) : $v)
 }
 !ref($_[$#_]) && $_[1]->{$_[$#_]} ? lng($_[0],1,$_[1]->{$_[$#_]}) : ''
}


sub die {
 &{$_[0]->{-die}}(@_[1..$#_])
}


sub warn {
 &{$_[0]->{-warn}}(@_[1..$#_])
}


sub start {	# start session
 my $s =shift;
 my %o =@_;
 $CACHE->{$s}	={};
 $s->{-c}	={};
 $s->{-var}->{'_handle'}->destroy if $s->{-var} && $s->{-var}->{'_handle'};
 $s->{-fetched} =0;
 $s->{-limited} =0;
 $s->{-affected}=0;
 $s->w32IISdpsn()	if (($ENV{SERVER_SOFTWARE}||'') =~/IIS/) 
			&& $ENV{REMOTE_USER}
			&& !$s->cgi->param('_qftwhere');
 $s->varLoad($s->{-serial} >2 ? LOCK_EX : $s->{-serial} >1 ? LOCK_SH : 0);
 $s->logOpen if $s->{-log} && !ref($s->{-log});
 $s->{-log}->lock(0) if ref($s->{-log});
 $s->set(@_);
 $s
}


sub end {	# end session
 my $s =shift;
 &{$s->{-end0}}($s) if $s->{-end0};
 $s->recCommit() if $s->{-dbi};
 delete $s->{-cgi};
 foreach my $k (sort keys %{$s->{-endh}}) {eval{&{$s->{-endh}->{$k}}($s)}};
 $s->{-endh} ={};
 $s->{-var}->{'_handle'}->destroy if $s->{-var} && $s->{-var}->{'_handle'};
 $s->{-log}->lock(0) if ref($s->{-log});
 $s->{-log}->destroy if ref($s->{-log});
 $s->{-log}	=undef;
 $s->{-c}	={};
 $CACHE->{$s}	={};
 &{$s->{-end1}}($s) if $s->{-end1};
 $s
}


sub setup {	# Setup script execution
 my ($s) =@_;

 print "Writing sample '.htaccess-$VERSION' file...\n";
 my $pth =$s->pthForm('tmp') && $s->{-path};
    $pth =~s/\\/\//g;
 $s->hfNew('+>', ($pth .'/.htaccess-' .$VERSION))->lock(LOCK_EX)
	->store( "# Default data and pulic directory tree configuration.\n"
		."# Should be included in 'httpd.conf'.\n"
		."# Include " .($pth .'/.htaccess-' .$VERSION) ."\n"
		."\n"
		."#<IfModule !mod_ntlm.c>\n"
		."#\tLoadModule ntlm_module modules/mod_ntlm.so\n"
		."#</IfModule>\n"
		."#<IfModule !mod_auth_sspi.c>\n"
		."#\tLoadModule sspi_auth_module modules/mod_auth_sspi.so\n"
		."#</IfModule>\n"
		."<Directory " .$pth ." >\n"
		."#\tAllowOverride All\n"
		."\tAllowOverride Limit AuthConfig\n"
		."\tOptions -FollowSymLinks\n"
		."\tAccessFileName .htaccess\n"
		."\tOrder Allow,Deny\n"
		."\tAllow from All\n"
		."#\t<IfModule mod_ntlm.c>\n"
		."#\t\tAuthType NTLM\n"
		."#\t\tNTLMAuth On\n"
		."#\t\tNTLMAuthoritative On\n"
		."#\t\tNTLMOfferBasic On\n"
		."#\t</IfModule>\n"
		."#\t<IfModule mod_auth_sspi.c>\n"
		."#\t\tAuthType SSPI\n"
		."#\t\tSSPIAuth On\n"
		."#\t\tSSPIAuthoritative On\n"
		."#\t\tSSPIOfferBasic On\n"
		."#\t</IfModule>\n"
		.($s->{-AuthUserFile}
		?"\tAuthUserFile " .$s->{-AuthUserFile} ."\n"
		:"#\tAuthUserFile ???\n")
		."\tAuthGroupFile " .($s->{-AuthGroupFile} ||($pth ."/var/uagroup")) ."\n"
		."</Directory>\n")
	->destroy;
 $s->pthForm('rfa');

 print "Executing <DATA>, some SQL DML error messages may be ignored...\n\n";
 local $s->{-dbiargpv}	=$s->{-dbiarg};
 local $s->{-affect}	=undef;
 local $s->{-rac}	=undef;
 my $row;
 my $cmd ='';
 my $cmt ='';
 while ($row =<main::DATA>) { $row =<main::DATA> if 0;
	chomp($row);
	if ($cmd && ($row =~/^#/)) {
		my $v;
		chomp($cmd);
		print $cmt ||$cmd, " -> ";
		local $SELF	=$s;
		local $_	=$s;
		if   ($cmd =~/^\s*\{/) {
			$v =eval($cmd);
			print $@ ? $@ : 'ok'
		}
		else {
			$v =$s->dbi->do($cmd);
			print $s->dbi->err ? $s->dbi->errstr : 'ok'
		}
		print ': ', defined($v) ? $v : 'undef', "\n\n";
		$cmd ='';
		$cmt ='';
	}
	if	($row =~/^\s*#*\s*$/ || $row =~/^\s+#/ || $row eq '') {
		next
	}
	elsif	($row =~/^#/) {
		$cmt =$row
	}
	else {
		$cmd .=($cmd ? "\n" : '') .$row
	}
 }
 $s
}


#########################################################
# Misc Data methods
#########################################################


sub dwnext {	# next digit-word string value
		# self, string, ? min length
 my $v =$_[1] ||'0';
 for(my $i =1; $i <=length($v); $i++) {
	next if ord(substr($v,-$i,1)) >=ord('z');
	substr($v,-$i,1)=chr(ord(substr($v,-$i,1) eq '9' ? chr(ord('a')-1) : substr($v,-$i,1)) +1);
	substr($v,-$i+1)='0' x ($i-1) if $i >1;
	return($_[2] && length($v) <$_[2] ? '0' x ($_[2] -length($v)) .$v : $v)
 }
 $v =chr(ord('0')+1) .('0' x length($v));
 $_[2] && length($v) <$_[2] ? '0' x ($_[2] -length($v)) .$v : $v
}


sub grep1 {	# first non-empty value
		# self, list
		# self, sub{}, list
 local $_;
 if (ref($_[1]) ne 'CODE') {
	foreach (@_[1..$#_]) {return($_) if $_}
 }
 else {
	my $t;
	foreach (@_[2..$#_]) {$t =&{$_[1]}(); return $t if $t}
 }
 return(())
}


sub max {	# maximal number
 (($_[1]||0) >($_[2]||0) ? $_[1] : $_[2])||0
}


sub min {	# minimal number
 (($_[1]||0) >($_[2]||0) ? $_[2] : $_[1])||0
}


sub orarg {	# argument of true result
 shift(@_);
 my $s =ref($_[0]) ? shift 
       :index($_[0], '-') ==0 ? eval('sub{' .shift(@_) .' $_}')
       :eval('sub{' .shift(@_) .'($_)}');
 local $_;
 foreach (@_) {return $_ if &$s($_)};
 undef
}


sub strpad {	# string padding
		# self, string, ?pad char, ?min length
 length($_[1]) <$NLEN ? ($_[2]||'0') x ($_[3] ||$NLEN -length($_[1])) .$_[1] : $_[1];
}


sub strdata {	# Stringify any data structure
  my $v =$_[1];	# self, data
 !defined($v) 
 ? ''
 : !ref($v)
 ? $v # ($v =~s/([\x00-\x1f\\])/sprintf("\\x%02x",ord($1))/eg ? $v : $v)
 : isa($v, 'ARRAY')
 ? join(', ', map {my $v =$_;
	  ref($v)
	? do {my $x =strdata($_[0],$v);
		 $x =~s/([\x00-\x1f,;=\\\)\(])/sprintf("\\x%02x",ord($1))/eg;
		 '(' .$x .')'
		}
	: !defined($v)
	? ''
	: $v =~s/([\x00-\x1f,;=\\\)\(])/sprintf("\\x%02x",ord($1))/eg
	? $v
	: $v
	} @$v)
 : isa($v, 'HASH')
 ? join(', ', map {my ($k, $v) =($_, $_[1]->{$_});
	$k =~s/([\x00-\x1f,;=\\\)\(])/sprintf("\\x%02x",ord($1))/eg;
	  ref($v)
	? do {my $x =strdata($_[0],$v);
		 $x =~s/([\x00-\x1f,;=\\\)\(])/sprintf("\\x%02x",ord($1))/eg;
		 $k .'=(' .$x .')'
		}
	: !defined($v)
	? "$k="
	: $v =~s/([\x00-\x1f,;=\\\)\(])/sprintf("\\x%02x",ord($1))/eg
	? "$k=$v"
	: "$k=$v"
	} sort keys %$v)
 : $v
}


sub strdatah {	# Stringify hash data structure
 return(strdata(@_)) if $#_ <2;
 my $r ='';
 for (my $i =1; $i <$#_; $i +=2) {
	my ($k, $v) =@_[$i, $i+1];
	$k	=~s/([\x00-\x1f,;=\\\)\(])/sprintf("\\x%02x",ord($1))/eg;
	$r	.=$k .'='
		.(!defined($v)
		? ''
		: ref($v)
		? do {my $x =strdata($_[0],$v);
			 $x =~s/([\x00-\x1f,;=\\\)\(])/sprintf("\\x%02x",ord($1))/eg;
			 '(' .$x .')'
			}
		: $v =~s/([\x00-\x1f,;=\\\)\(])/sprintf("\\x%02x",ord($1))/eg
		? $v
		: $v)
		.','
 }
 chop($r);
 $r
}


sub strquot {	# Quote and Escape string
 my $v =$_[1];
 return('undef') if !defined($v);
 $v =~s/([\\'])/\\$1/g;
 $v =~s/([\x00-\x1f])/sprintf("\\x%02x",ord($1))/eg;
 $v =~/^\d+$/ ? $v : ('\'' .$v .'\'');
}



sub datastr {	# Data structure from String
		# (for data structure strings only!)
		# self, string, ?unescape
 my $v =$_[1];
    $v =~s/\\x([0-9a-fA-F]{2})/chr hex($1)/eg if $_[2];
    $v =~/^[^\(\)]+[=]/
 ? {map { my ($n, $v) =(/^\s*([^=]+)\s*=\s*(.*)$/ ? ($1,$2) : ());
	   !defined($n) ||($n eq '')
	?  ()
	:  !defined($v)
	? ($n =>$v)
	:  $v =~/^\(/
	? ($n =>datastr($_[0], substr($v,1,-1), 1) ||undef)
	:  $v =~s/\\x([0-9a-fA-F]{2})/chr hex($1)/eg
	? ($n =>$v)
	: ($n =>$v)
	} split /\s*[,;]\s*/, $v}
 : $v =~/[,;]/
 ? [grep {defined($_)} map { 
	!defined($_)
	? ()
	: /^\(/
	? datastr($_[0], substr($_,1,-1), 1) ||undef
	: s/\\x([0-9a-fA-F]{2})/chr hex($1)/eg
	? $_
	: $_
	} split / *[,;] */, $v]
 : $v =~s/\\x([0-9a-fA-F]{2})/chr hex($1)/eg
 ? $v
 : $v
}

sub dsdClone {	# Clone data structure
   !ref($_[1]) ? $_[1]
 : ref($_[1]) eq 'ARRAY' ? [map {ref($_) ? dsdClone($_[0], $_) : $_} @{$_[1]}]
 : ref($_[1]) eq 'HASH'  ? {map {($_, dsdClone($_[0], $_[1]->{$_}))} keys %{$_[1]}}
 : $_[1]
}


sub dsdMk {     # Data structure dump to string
 my ($s, $d) =@_;
 eval('use Data::Dumper');
 my $o =Data::Dumper->new([$d]); 
 $o->Indent(1);
 $o->Dump();
}


sub dsdParse {  # Data structure dump string to perl structure
 my ($s, $d) =@_;
 eval('use Safe');
 Safe->new()->reval($d)
}


sub strtime {	# Stringify Time
 my $s =shift;
 my $msk =@_ ==0 || $_[0] =~/^\d+$/i ? 'yyyy-mm-dd hh:mm:ss' : shift;
 my @tme =@_ ==0 ? localtime(time) : @_ ==1 ? localtime($_[0]) : @_;
 $msk =~s/yyyy/%Y/;
 $msk =~s/yy/%y/;
 $msk =~s/mm/%m/;
 $msk =~s/mm/%M/i;
 $msk =~s/dd/%d/;
 $msk =~s/hh/%H/;
 $msk =~s/hh/%h/i;
 $msk =~s/ss/%S/;
#eval('use POSIX');
 POSIX::strftime($msk, @tme)
}


sub timestr {	# Time from String
 my $s   =shift;
 my $msk =@_ <2 || !$_[1] ? 'yyyy-mm-dd hh:mm:ss' : shift;
 my $ts  =shift;
 my %th;
 while ($msk =~/(yyyy|yy|mm|dd|hh|MM|ss)/) {
    my $m=$1; $msk =$';
    last if !($ts =~/(\d+)/);
    my $d =$1; $ts   =$';
    $d   -=1900   if $m eq 'yyyy' ||$m eq '%Y';
    $m    =chop($m);
    $m    ='M'    if $m eq 'm' && $th{$m};
    $m    =lc($m) if $m ne 'M';
    $th{$m}=$d;
 }
#eval('use POSIX');
 POSIX::mktime($th{'s'}||0,$th{'M'}||0,$th{'h'}||0,$th{'d'}||0,($th{'m'}||1)-1,$th{'y'}||0)
}


sub timeadd {	# Adjust time to years, months, days,...
 my $s =shift;
 my @t =localtime(shift);
 my $i =5;
 foreach my $a (@_) {$t[$i] += ($a||0); $i--}
#eval('use POSIX');
 POSIX::mktime(@t[0..5])
}


sub cptran {	# Translate strings between codepages
 my ($s,$f,$t,@s) =@_; 
 foreach my $v ($f, $t) {
   if    ($v =~/oem|866/i)   {$v ='ЂЃ‚ѓ„…р†‡€‰Љ‹ЊЌЋЏђ‘’“”•–—™њ›љќћџ ЎўЈ¤Ґс¦§Ё©Є«¬­®Їабвгдежзиймлкноп'}
   elsif ($v =~/ansi|1251/i) {$v ='АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюя'}
   elsif ($v =~/koi/i)       {$v ='бвчздеіцъйклмнопртуфхжигюыэшщяьасБВЧЗДЕЈЦЪЙКЛМНОПРТУФХЖИГЮЫЭШЩЯЬАС'}
   elsif ($v =~/8859-5/i)    {$v ='°±ІіґµЎ¶·ё№є»јЅѕїАБВГДЕЖЗИЙМЛКНОПРСТУФХсЦЧШЩЪЫЬЭЮЯабвгдежзиймлкноп'}
 }
 map {eval("~tr/$f/$t/")} @s; 
 @s >1 ? @s : $s[0];
}


sub ishtml {	# Looks like HTML?
 ($_[1] ||'') =~m/^<(?:(?:B|BIG|BLOCKQUOTE|CENTER|CITE|CODE|DFN|DIV|EM|I|KBD|P|SAMP|SMALL|SPAN|STRIKE|STRONG|STYLE|SUB|SUP|TT|U|VAR)\s*>|(?:BR|HR)\s*\/{0,1}>|(?:A|BASE|BASEFONT|DIR|DIV|DL|!DOCTYPE|FONT|H\d|HEAD|HTML|IMG|IFRAME|MAP|MENU|OL|P|PRE|TABLE|UL)\b)/i
}


sub htmlEscape {
 join '',
 map {	my $v =$_; return('') if !defined($_);
	$v =~s{&}{&amp;}gso;
	$v =~s{<}{&lt;}gso;
	$v =~s{>}{&gt;}gso;
	$v =~s{"}{&quot;}gso;
	$v
     } @_[1..$#_]
}


sub htmlEscBlnk {
 join '',
 map {	my $v =$_; return('&nbsp;') if !defined($_) || $_ eq '';
	$v =~s{&}{&amp;}gso;
	$v =~s{<}{&lt;}gso;
	$v =~s{>}{&gt;}gso;
	$v =~s{"}{&quot;}gso;
	$v
     } @_[1..$#_]
}


sub htmlUnescape {
 join '',
 map {	my $v =$_; return('') if !defined($_);
	$v =~s[&(.*?);]{
   	    local $_ = $1;
		/^amp$/i	? "&" :
		/^quot$/i	? '"' :
		/^gt$/i		? ">" :
		/^lt$/i		? "<" :
		$_;
	}gex;
	$v
 } @_[1..$#_]
}


sub urlEscape {
 join '',
 map {	my $v =$_; return('') if !defined($_);
	$v =~s/([^a-zA-Z0-9_.-])/uc sprintf("%%%02x",ord($1))/eg;
	$v
 } @_[1..$#_]
}


sub urlUnescape {
 join '',
 map {	local $_ =$_; return('') if !defined($_);
	tr/+/ /;
	s/%([0-9a-fA-F]{2})/chr hex($1)/ge;
 } @_[1..$#_]
}


sub urlCat {
 my $r =$_[1] .'?';
 for (my $i =2; $i <$#_; $i+=2) {$r .=urlEscape($_[0], $_[$i]) .'=' .urlEscape($_[0], $_[$i+1]) .$HS}
 chop($r);
 $r
}


sub xmlEscape {
 join '',
 map {	my $v =$_; return('') if !defined($v);
	$v =~s/([\\"<])/\\$1/g;
      # $v =~s/([^\w\d ,<.>\/?:;"'\[\]{}`~!@#$%^&*()-_=+\\|])/ ord($1) < 0x20 ? sprintf('\\x%02x',ord($1)) : $1/eg;
	$v =~s/([\x00-\x1F])/sprintf('\\x%02x',ord($1))/eg;
	$v
 } @_[1..$#_]
}


sub xmlAttrEscape {
 xmlEscape(@_)
}


sub xmlTagEscape {
 join '',
 map {	my $v =$_; return('') if !defined($v);
	$v =~s/([\\"<])/\\$1/g;
      # $v =~s/([^\w\d\s\n ,<.>\/?:;"'\[\]{}`~!@#$%^&*()-_=+\\|])/ ord($1) < 0x20 ? sprintf('\\x%02x',ord($1)) : $1/eg;
	$v =~s/([\x00-\x08\x0B-\x0C\x0E-\x1F])/sprintf('\\x%02x',ord($1))/eg;
		# \t=0x09; \n=0x0A; \r=0x0D;
	$v
 } @_[1..$#_]
}


sub xmlUnescape {
 join '',
 map {	my $v =$_; return('') if !defined($v);
	$v =~s/\\\\/\\/g;
	$v =~s|(\\+)([<"])| int(length($1)/2)*2 == length($1) ? ('\\' x (length($1)-1) .$2) : ($1 .$2)|ge;
	$v =~s|(\\+)(x\d+)| int(length($1)/2)*2 == length($1) ? ('\\' x (length($1)-1) .chr(hex($2))) : ($1 .$2)|ge;
	$v
 } @_[1..$#_]
}


sub lsTag {	# Attribute list to tag strings list 
 my($c, $v, $n);# htmlEscape, urlEscape, tagEscape, self, tagname, attr=>value,...
 $#_+1 !=2*int(($#_+1)/2)
 ? 0
 : substr($_[$#_],0,1) eq "\n"
 ? ($n =$_[$#_])
 : ($c =$_[$#_]);
 ((!ref($_[$[+4])
 ? ('<', $_[$[+4]
   ,(map  {$_[$_]
 	  ? (defined($_[$_+1]) 
	    ? (' ', substr($_[$_],0,1) eq '-' ? substr($_[$_],1) : $_[$_], '="'
	       , &{$_[$_] ne 'href' ? $_[$[] : $_[$[+1]}
	        ($_[$[+3], !ref($_[$_+1]) ? $_[$_+1] : strdata($_[$[+3], $_[$_+1]))
	      , '"') 
	    : ())
	  : eval{$c =$_[$_]; $v =$_[$_+1]; ()}
	  } map {$_*2+3} $[+1..int(($#_-3)/2) )
   ,(!defined($c)
     ? ' />'
     : $c eq '0'
     ? '>'
     :  ('>'
       ,  (ref($v) eq 'CODE') && ($v =&{$v}) && 0
	  ? ()
     	  : ref($v) eq 'ARRAY'
     	  ? &lsTag(@_[$[..$[+3], $v)
	  : defined($v)
	  ? &{$_[$[+2]}($_[$[+3], $v)
	  : ()
       , '</', $_[$[+4], '>') )
   )
 : ref($_[$[+4]) eq 'ARRAY'
 ? (map {ref($_) ne 'ARRAY' ? &{$_[$[+2]}($_[$[+3], $_) : lsTag(@_[$[..$[+3], @$_)} @{$_[$[+4]})
 : ref($_[$[+4]) eq 'HASH' && eval{$v =$_[$[+4]; $c =$v->{'-'}||$v->{'-tag'}||'tag'}
 ? ('<', $c
   ,(map {defined($v->{$_}) 
         ?(' '
	  , substr($_,0,1) eq '-' ? substr($_, 1) : $_, '="'
	  , &{$_ ne 'href' ? $_[$[] : $_[$[+1]}
	    ($_[$[+3], !ref($v->{$_}) ? $v->{$_} : strdata($_[$[+3], $v->{$_}))
          ,'"')
         :()
         } 
         sort grep {$_ && $_ !~/^-(tag|data|)$/} keys %$v)
   , (grep {exists($v->{$_}) && eval{$v =$v->{$_}}} '', '-data')
   ? ('>'
     ,(ref($v) eq 'CODE') && ($v =&{$v}) && 0
      ? ()
      : ref($v) eq 'ARRAY'
      ? &lsTag(@_[$[..$[+3], $v)
      : defined($v)
      ? &{$_[$[+2]}($_[$[+3], $v)
      : ()
     ,'</',$c,'>')
   : exists($v->{0})  
   ? '>'
   : ' />'
   )
 : ()
 ), !$n ? () : $n)
}


sub htlsTag {	# Attribute list to html strings list
 lsTag(\&htmlEscape, \&urlEscape, \&htmlEscape, @_)
}


sub xmlsTag {	# Attribute list to xml strings list
 lsTag(\&xmlAttrEscape, \&xmlAttrEscape, \&xmlTagEscape, @_)
}


#########################################################
# Misc Utility methods
#########################################################


sub cgi {       # CGI object
 return($_[0]->{-cgi}) if $_[0]->{-cgi};
 eval("use CGI; 1") || &{$_[0]->{-die}}("use CGI -> $@");
 $_[0]->{-cgi} =eval("CGI->new()")
	|| &{$_[0]->{-die}}("CGI::new() -> $@");
}


sub dbi {       # DBI connection object
 return ($_[0]->{-dbi}) if $_[0]->{-dbi};
 $_[0]->{-dbi} =eval("use DBI; 1;")
		&& DBI->connect(ref($_[0]->{-dbiarg}) 
				? @{$_[0]->{-dbiarg}}
				: $_[0]->{-dbiarg})
		|| &{$_[0]->{-die}}($_[0]->lng(0,'dbi') .": DBI::conect() -> failure\n");
 $_[0]->{-dbi}->{AutoCommit} =$_[0]->{-autocommit};
 $_[0]->{-dbi}
}


sub hfNew {     # New file handle object
 local $SELF =$_[0];
 DBIx::Web::FileHandle->new(-parent=>$_[0]
	,@_ >2 ? (-mode=>$_[1], -name=>$_[2]) 
	:@_ >1 ? (-name=>$_[1])
	: ())
}


sub ccbNew {	# New condition code block object
 local $SELF =$_[0];
 DBIx::Web::ccbHandle->new($_[1])
}


sub dbmNew {	# New isam datafile object
 local $SELF =$_[0];
 DBIx::Web::dbmHandle->new(-parent=>$_[0], @_ >2 ? @_[1..$#_] : (-name=>$_[1]))
}


sub dbmTable {	# Get isam datafile object
 return(&{$_[0]->{-die}}('Bad table \'' .$_[1] .'\'')) if !$_[1];
   $CACHE->{$_[0]}->{'-dbm/' .$_[1]}
||($CACHE->{$_[0]}->{'-dbm/' .$_[1]}
	=$_[0]->dbmNew(	 -name	=>$_[0]->pthForm('dbm'
				,( $_[0]->{-table}->{$_[1]} 
				&& $_[0]->{-table}->{$_[1]}->{-expr} 
				|| $_[1]))
			,-table	=>$_[0]->{-table}->{$_[1]}
			,-lock	=>LOCK_SH))->opent
}


sub osCmd {     # OS Command
                # -'i'gnore retcode
  my $s   =shift;
  my $opt =substr($_[0],0,1) eq '-' ? shift : ''; 
  my $sub =ref($_[$#_]) eq 'CODE' ? pop : undef;
  my $r;
  my $o;
  local(*RDRFH, *WTRFH);
  $s->logRec('osCmd', @_);
  if ($^O eq 'MSWin32' 	        # !!! arguments may need to be quoted
   || $^X =~/perlis\.dll$/i) {	# ISAPI, DB_File operation problem hacks
     if (!$sub) {
        my $c =join(' ', @_) .' 2>&1';
        @$o =`$c`
     }
     else {                     # !!! command's output will be lost
        open(WTRFH, '|-', join(' ', @_) .' >nul 2>&1') && defined(*WTRFH) 
        || return(&{$_[0]->{-die}}(join(' ',$s->lng(0,'osCmd'),@_) .' -> ' .$!)||0);
        my $ls =select(); select(WTRFH); $| =1;
        &$sub($s) if $sub;
        select($ls);
        eval{close(WTRFH)}
     }
  }
  else {
     eval('use IPC::Open2');
     my $pid = IPC::Open2::open2(\*RDRFH, \*WTRFH, @_); 
     if ($pid) {
        if ($sub) {
           my $select =select();
           select(WTRFH);
           $| =1;
           &$sub($s);
           select($select);
        }
        @$o =<RDRFH>;
        waitpid($pid,0);
     }
  }
  $r =$?>>8;
  return(&{$s->{-die}}(join(' ',$s->lng(0,'osCmd'),@_) .($opt !~/h/ ? '' : ' -> ' .join('',@{$o||[]})) ." -> $r")||0) 
       if $r && $opt !~/i/;
  if ($o) {foreach my $e (@$o) {
	chomp($e);
	$s->logRec('osCmd',$e)
  }}
  !$r ? $o ||[] : undef
}


sub nfopens {	# opened files (`net file`)
		# (mask, ?container)
 return(undef) if $^O ne 'MSWin32';
 my $rc =$_[2]||[];
 my $mask =$_[1]||''; $mask =~s/\//\\/ig;
#[map {chomp($_); $_} map {/^\d+\s+(.+)\s+\d+[\n\r\s]*$/ ? $1 : $_} grep /^\d+\s*\Q$mask\E/i, `net file`]
 my $o =eval('use Win32::OLE; Win32::OLE->Option("Warn"=>0); Win32::OLE->GetObject("WinNT://'
	.(eval{Win32::NodeName()}||$ENV{COMPUTERNAME}) .'/lanmanserver")');
 return(undef) if !$o;
 if (ref($rc) eq 'HASH') {
	%$rc =map {(substr($_->{Path}, length($mask)+1), $_->{User} .': ' .substr($_->{Path}, length($mask)+1))
		} grep {(eval{$_->{Path}}||'') =~/^\Q$mask\E/i
			} Win32::OLE::in($o->Resources());
	# %$rc =(1=>'1.1',2=>'2.1',3=>'3.1');
	$rc =undef if !%$rc
 }
 else {
	@$rc =map {eval{substr($_->{Path}, length($mask)+1)}
		} grep {(eval{$_->{Path}}||'') =~/^\Q$mask\E/i  # $_->GetInfo;
			} Win32::OLE::in($o->Resources());
	$rc =undef if !@$rc
 }
 $rc
}


sub nfclose {	# close opened files (`net file /close`)
		# (mask, [filelist])
 return(0) if $^O ne 'MSWin32';
 my $mask =$_[1]||''; $mask =~s/\//\\/ig;
 my $list =$_[2]||[];
 my $o =eval('use Win32::OLE; Win32::OLE->Option("Warn"=>0); Win32::OLE->GetObject("WinNT://'
	.(eval{Win32::NodeName()}||$ENV{COMPUTERNAME}) .'/lanmanserver")');
 return(0) if !$o;
 foreach my $f (grep {$_ && (eval{$_->{Path}}||'')=~/^\Q$mask\E/i
			} Win32::OLE::in($o->Resources())) {
	my $n =eval{$f->{Path} =~/^\Q$mask\E[\\\/]*(.+)/i ? $1 : undef};
	next if !$n || !grep /^\Q$n\E$/i, @$list;
	$_[0]->osCmd('net','file',$f->{Name},'/close');
 }
 1
}


sub output {    # Output to user, like print, but redefinable
  (!$_[0]->{-output} ? print @_[1..$#_] : &{$_[0]->{-output}}(@_)) 
 && $_[0]
}


sub outhtm  {	# Output HTML tag
  output($_[0], htlsTag(@_))
}

sub outhtml {	# Output HTML tag
  output($_[0], htlsTag(@_))
}


sub outxml  {	# Output XML tag
  output($_[0], xmlsTag(@_))
}


#########################################################
# Filesystem methods
#########################################################


sub pthForm {  # Form filesystem path for 'tmp'|'log'|'var'|'dbm'|'rfa'
 join('/', $_[0]->{-c}->{'-pth_' .$_[1]} ||pthForm_(@_), @_[2..$#_]);
}


sub pthForm_{
 my $p =($_[0]->{-c}->{'-pth_' .$_[1]} 
       =($_[1] eq 'tmp' && ($ENV{TMP} ||$ENV{tmp} ||$ENV{TEMP} ||$ENV{temp}))
	||($_[0]->{-cgibus} && ($_[1] eq 'rfa') && $_[0]->{-cgibus})
	||join('/', $_[0]->{-path}, $_[1]));
 if (!-d $p) {
	$_[0]->pthMk($p);
	$_[0]->hfNew('+>', "$p/.htaccess")->lock(LOCK_EX)
		->store("<Files * >\nOrder Deny,Allow\nDeny from All\n</Files>\n")
		->destroy
		if $_[1] ne 'rfa';
	if ($ENV{OS} && $ENV{OS}=~/Windows_NT/i && ($_[1] ne 'rfa')) {
		$p =~s/\//\\/g;
		$_[0]->osCmd('cacls', "\"$p\"", '/T','/C','/G'
		,(map{(m/([^@]+)\@([^@]+)/ ? "$2\\$1" : $_) .':F'
			} ref($_[0]->{-fswtr}) 
			? (@{$_[0]->{-fswtr}}) 
			: ($_[0]->{-fswtr}))
		,sub{CORE::print "Y\n"})
	}
 }
 $p
}


sub pthMk {    # Create directory if needed
  return(1) if -d $_[1];
  my $a ='';
  foreach my $e (split /\//, $_[1]) {
     $a .=$e;
     if (!-d $a) {
	$_[0]->logRec('mkdir', $a) if !$_[0]->{-log} ||ref($_[0]->{-log});
        mkdir($a, 0777) ||return(&{$_[0]->{-die}}($_[0]->lng(0,'pthMk') .": mkdir('$a') -> $!")||0);
     }
     $a .='/'
  }
  2;
}


sub pthGlob {  # Glob directory
  my $s =shift;
  my @ret;
  if    ($^O ne 'MSWin32') {
     CORE::glob(@_)
  }
  elsif (-e $_[0]) {
     push @ret, $_[0];
     @ret
  }
  else {
     my $msk =($_[0] =~/([^\/\\]+)$/i ? $1 : '');
     my $pth =substr($_[0],0,-length($msk));
     $msk =~s/\*\.\*/*/g;
     $msk =~s:(\(\)[].+^\-\${}[|]):\\$1:g;
     $msk =~s/\*/.*/g;
     $msk =~s/\?/.?/g;
     local (*DIR, $_); 
     opendir(DIR, $pth eq '' ? './' : $pth) 
           || return(&{$s->{-die}}($s->lng(0,'pthGlob') .": opendir('$pth') -> $!")||0);
     while(defined($_ =readdir(DIR))) {
       next if $_ eq '.' || $_ eq '..' || $_ !~/^$msk$/i;
       push @ret, "${pth}$_";
     }
     closedir(DIR) || return(&{$s->{-die}}($s->lng(0,'pthGlob') .": closedir('$pth') -> $!")||0);
     @ret
  }
}


sub pthGlobn { # Glob filenames only
 map {$_ =~/[\\\/]([^\\\/]+)$/ ? $1 : $_} shift->pthGlob(@_)
}


sub pthRm {    # Remove filesystem path
               # '-r' - recurse subdirectories, 'i'gnore errors
  my $s   =shift;
  my $opt =$_[0] =~/^\-/ || $_[0] eq '' ? shift : '';
  my $ret =1;
  $s->logRec('pthRm',$opt,@_);
  foreach my $par (@_) {
    foreach my $e ($s->pthGlob($par)) {
      if (-d $e) {
         if ($opt =~/r/i && !$s->pthRm($opt,"$e/*")) {
               $ret =0
         }
         elsif (!rmdir($e)) {
               $ret =0;
               $opt =~/i/i || return(&{$_[0]->{-die}}($s->lng(0, 'pthRm') .": rmdir('$e') -> $!")||0);
         }
      }
      elsif (-f $e && !unlink($e)) {
            $ret =0;
            $opt =~/i/i || return(&{$_[0]->{-die}}($s->lng(0, 'pthRm') .": unlink('$e') -> $!")||0);
      }
    }
  }
  $ret
}


sub pthCln {   # Clean unused (empty) directory
  return(0) if !-d $_[1];
  my ($s, $d) =@_;
  my @g =$s->pthGlob("$d/*");
  return(0) if scalar(@g) >1 
            || scalar(@g) ==1 && $g[0] !~/\.htaccess$/i;
  foreach my $f (@g) { unlink($f) };
  while ($d && rmdir($d)) { $d =($d =~m/^(.+)[\\\/][^\\\/]+$/ ? $1 : '') };
  !-d $d
}


sub pthCp {    # Copy filesystem path
               # -'d'irectory or 'f'ile hint; 'r'ecurse subdirectories, 'i'gnore errors
  my $s   =shift;
  my $opt =$_[0] =~/^-/i ? shift : '';
  my ($src,$dst) =@_;
  $opt =~s/-//g;
  if ($^O eq 'MSWin32' 
     && (eval{Win32::IsWinNT} ||(($ENV{OS}||'') =~/Windows_NT/i))) {
     $src =~tr/\//\\/;
     $opt ="${opt}Z";
     $opt ="${opt}Y" if (eval{(Win32::GetOSVersion())[1]} ||0) >=5
  }
  elsif ($^O eq 'MSWin32') {
     $src =~tr/\//\\/;
     $dst =~tr/\//\\/
  }
  if ($^O ne 'MSWin32' && $^O ne 'dos') {
     $opt =~ tr/fd//;
     $opt ="-${opt}p";
     $opt =~ tr/ri/Rf/;
     $s->osCmd('cp', $opt, @_)
  }
  else {
     my $rsp =($opt =~/d/i ? 'D' : $opt =~/f/i ? 'F' : '');
     $opt =~s/(r)/SE/i; $opt =~s/(i)/C/i; $opt =~s/[fd]//ig; $opt =~s/(.{1})/\/$1/gi;
     my @cmd =('xcopy',"/H/R/K/Q$opt","\"$src\"","\"$dst\"");
     push @cmd, sub{CORE::print($rsp)} if $rsp && ($ENV{OS} && $ENV{OS}=~/windows_nt/i ? !-e $dst : !-d $dst);
     $s->osCmd(@cmd)
  }
}


#########################################################
# Variables & Logging Methods
#########################################################


sub varFile {   # Common variables filename
 $_[0]->pthForm('var','var.pl');
}


sub varLoad {   # Load common variables
 my ($s, $lck) =@_;
 return($s->{-var}) if $s->{-var} && !$lck;
 my $fn =$s->varFile;
 my $hf;
 if (!-f $fn) {
    $s->{-var} ={'id'=>'DBIx-Web-variables'};
    $s->varStore();
 }
 $hf =$s->hfNew('+<',$fn)->lock($lck||LOCK_SH);
 $s->{-var} =$hf->{-buf} =$hf->load && $s->dsdParse($hf->{-buf});
 $s->{-var}->{'_handle'} =$hf;
 $hf->close() if !$lck;
 $s
}


sub varLock  {	# Lock common variables file
 !$_[0]->{-var} ||!$_[0]->{-var}->{'_handle'}
 ? $_[0]->varLoad($_[1] ||LOCK_EX)
 : $_[0]->{-var}->{'_handle'}->lock($_[1] ||LOCK_EX)
}


sub varStore {  # Store common variables
 my $s  =shift;
 my $hf = !$s->{-var} ||!$s->{-var}->{'_handle'}
        ? $s->hfNew('+>',$s->varFile) 
        : $s->{-var}->{'_handle'};
 delete($s->{-var}->{'_handle'});

 $hf->lock(LOCK_EX)->store($s->dsdMk($s->{-var}))->close();

 $hf->{-buf} =$s->{-var};
 $s->{-var}->{'_handle'} =$hf;
 $s
}


sub logOpen {   # Log File open
 return($_[0]->{-log}) if ref($_[0]->{-log});
 my $fn =$_[0]->pthForm('log','cmdlog.txt');
 $_[0]->{-log} =$_[0]->hfNew('+>>', $fn);
 $_[0]->{-log}->select(sub{$|=1});
 $_[0]->{-log}
}


sub logLock {   # Log File lock
 $_[0]->logOpen if !ref($_[0]->{-log});
 $_[0]->{-log}->lock(@_[1..$#_]);
}


sub logRec {    # Add record to log file
 return(1) if !$_[0]->{-log} && !$_[0]->{-logm};
 $_[0]->logOpen() if $_[0]->{-log} && !ref($_[0]->{-log});
 $_[0]->{-log}->print(strtime($_[0]),"\t",$_[0]->user,"\t",logEsc($_[0],@_[1..$#_]),"\n") if $_[0]->{-log};
 $_[0]->{-c}->{-logm} =[] if $_[0]->{-logm} && !$_[0]->{-c}->{-logm};
 splice @{$_[0]->{-c}->{-logm}}, 2, 2, '...' if $_[0]->{-logm} && scalar(@{$_[0]->{-c}->{-logm}}) >$_[0]->{-logm};
 push @{$_[0]->{-c}->{-logm}}, $_[0]->logEsc(@_[1..$#_]) if $_[0]->{-logm};
 1
}


sub logEsc {	# Escape list for logging
 my $s =$_[0];
 my $b =" ";
 my $r =$_[1] .$b;
 for (my $i=2; $i <=$#_; $i++) {
	my $v =$_[$i];
	$r .=	( !defined($v)
		? 'undef,'
		: ref($v) eq 'ARRAY'
		? '[' .join(', '
			,map {strquot($s, $_);
			} @$v) .'],'
		: isa($v,'HASH')
		? '{' .join(', '
			,map {(defined($_) && $_ =~/^-\w+[\d\w]*$/
				? $_
				: strquot($s, $_)) .'=>' .strquot($s, $v->{$_})
			} sort keys %$v) .'},'
		: $v =~/^\d+$/
		? $v .','
		: $v =~/^-\w+[\d\w]*$/
		? $v .'=>'
		: $v =~/^(select|insert|update|delete|drop|commit|rollback)\s+/i && $i ==2
		? $v .';'
		: (strquot($s, $v) .',')) .$b
 }
 $r =~/^(.+?)[\s,;=>]*$/ ? $1 : $r
}



#########################################################
# User & Group names methods
#########################################################


sub user {	# current user name
 return($_[0]->{-userln} ? userln(@_) : $_[0]->{-c}->{-user})
	if $_[0]->{-c}->{-user};
 $_[0]->{-c}->{-user} =
   $_[0]->{-user}   ? (ref($_[0]->{-user}) ? &{$_[0]->{-user}}(@_) : $_[0]->{-user})
 : $_[0]->{-unames} ? $_[0]->unames->[0]
 : $_[0]->{-tn}->{-guest};
 $_[0]->{-c}->{-user} =
	$_[0]->{-usernt}
	? ($_[0]->{-c}->{-user} =~/^([^\@]+)\@(.+)$/ ? $2 .'\\' .$1 : $_[0]->{-c}->{-user})
	: ($_[0]->{-c}->{-user} =~/^([^\\]+)\\(.+)$/ ? $2 .'@'  .$1 : $_[0]->{-c}->{-user});
#$_[0]->logRec('user', $_[0]->{-c}->{-user});
 $_[0]->{-userln} ? userln(@_) : $_[0]->{-c}->{-user}
}


sub userln {	# current user local name
 return($_[0]->{-c}->{-userln})        if $_[0]->{-c}->{-userln};
 my $s =$_[0];
 my $un=$s->{-c}->{-user} ||$s->user();
 my ($d, $u) =	  $un =~/^([^\\]+)\\(.+)$/ ? ($1, $2)
		: $un =~/^([^\@]+)\@(.+)$/ ? ($2, $1)
		: ('', $un);
 $s->{-c}->{-userln} =
	  $^O eq 'MSWin32' && lc($d) eq lc($s->w32domain())
	? $u
	: eval('use Sys::Hostname; Sys::Hostname::hostname()') =~/\Q$d\E$/i
	? $u
	: $un
}


sub uguest {	# is current user a guest
 lc($_[0]->user()) eq lc($_[0]->{-tn}->{-guest})
}


sub unames {	# current user names
 return($_[0]->{-c}->{-unames})        if $_[0]->{-c}->{-unames};
 $_[0]->{-c}->{-unames} =
   $_[0]->{-unames} ? (ref($_[0]->{-unames}) ? &{$_[0]->{-unames}}(@_) : $_[0]->{-unames})
 : $_[0]->{-user}   ? [$_[0]->user()
			, $_[0]->user() =~/^([^\\@]+)([\\@])([^\\@]+)$/
				? ($2 eq '@'	? "$3\\$1"
						: "$3\@$1")
				: ()
			, $_[0]->user() ne $_[0]->userln()
				? ($_[0]->userln())
				: ()
			]		
 : [$_[0]->{-tn}->{-guest}];
 $_[0]->logRec('unames', $_[0]->{-c}->{-unames});
 $_[0]->{-c}->{-unames}
}


sub ugroups {	# current user groups
		# (self, ?user) -> [user's groups]
 return($_[0]->{-c}->{-ugroups})        if !$_[1] && $_[0]->{-c}->{-ugroups};
 if ($_[0]->{-ugroups}) {
	return($_[0]->{-c}->{-ugroups} =ref($_[0]->{-ugroups}) eq 'CODE'
		? &{$_[0]->{-ugroups}}(@_)
		: $_[0]->{-ugroups})
 }
 my $s =$_[0];
 my $un=$_[1] ||$s->user();
 my $ul=$_[1] ||$s->userln();
 my $ug=undef;
 my $fn=undef;
 my $rs='';
 if	((($fn =$s->{-AuthGroupFile}) 
	 ||(($^O eq 'MSWin32')
	  && $s->w32agf()
	  &&($fn =$s->pthForm('var','uagroup')) 
	))
	&& -f $fn) {
	my $fh=$s->hfNew('<', $fn)->lock(LOCK_SH);
	$ug =[];
	while(my $r =$fh->readline()) {
		next if $r !~/[:\s](?:\Q$un\E|\Q$ul\E)(?:\s|\Z)/i;
		next if $r !~/^([^:]+):/;
		push @$ug, $1
	}
	$fh->close();
	$ug =undef if !@$ug;
 }
 elsif	(0	# !!! lost code, for possible w32agf extension
	&& $^O eq 'MSWin32'
	&& $s->w32agf()
	&& ($fn =$s->pthForm('var','ualist')) 
	&& -f $fn) {
	my $fh=$s->hfNew('<', $fn)->lock(LOCK_SH);
	while(my $r =$fh->readline()) {
		if ($r =~/^(?:\w+\\){0,1}\Q$ul\E:(.+)/i
		||  $r =~/^Q$un\E:(.+)/i) {
			$rs=$r;	$r =$1;
			chomp($rs); chomp($r);
			$ug =[split /\t/, $r];
			last
		}
	 }
	 $fh->close();
 }
 if ($ug) {
	$s->logRec('ugroups', $rs =~/^([^:]+):/ ? $1 : $rs, 'file', $ug)
 }
 else {
	$ug =[$s->{-tn}->{-guests}, $s->uguest ? () : ($s->{-tn}->{-users})];
	$s->logRec('ugroups', $un, 'default', $ug)
 }
 if ($s->{-ugflt}) {
	my $fg =$s->{-ugflt};
	$ug =[map {&$fg($s) ? ($_) : ()
			} @$ug]
 }
 $s->{-c}->{-ugroups} =$ug if !$_[1];
 $ug
}


sub ugnames {	# current user and group names
		# (self, ?user) -> [user's names]
 if ($_[1]) {
	# return([$_[1]]);
	local $_[0]->{-c}->{-user}	=$_[1];
	local $_[0]->{-c}->{-ugroups}	=undef;
	local $_[0]->{-c}->{-unames}	=undef;
	local $_[0]->{-c}->{-ugrexp}	=undef;
	return($_[0]->ugnames())
 }
 elsif ($_[0]->{-c}->{-ugnames}) {
	return($_[0]->{-c}->{-ugnames})
 }
 $_[0]->{-c}->{-ugnames} =[map {$_} @{$_[0]->unames()}, map {$_} @{$_[0]->ugroups()}]
}


sub ugrexp {	# current user and group names regexp source
 return($_[0]->{-c}->{-ugrexp}) if $_[0]->{-c}->{-ugrexp};
 my $n =join('|', @{$_[0]->ugnames()}); $n =~s/([\\.?*\$\@])/\\$1/g;
 $_[0]->{-c}->{-ugrexp} =eval('sub{(($_[0]=~/\\b(' . $n.')\\b/i) && $1)}')
}


sub ugmember {	# user group membership
 my $e =$_[0]->{-c}->{-ugrexp} ||ugrexp($_[0]);
 foreach my $i (@_[1..$#_]) {
	if (ref($i))	{foreach my $j (@$i) {defined($j) && &$e($j) && return($_[0]->{-c}->{-user})}}
	else		{defined($i) && &$e($i) && return($_[0]->{-c}->{-user})}
 }
 undef
}


sub uadmin {	# user admin groups membership
 uadmwtr(@_)
}


sub uadmwtr {	# user admin writer groups membership
 return($_[0]->{-c}->{-uadmwtr}) if exists($_[0]->{-c}->{-uadmwtr});
 $_[0]->{-c}->{-uadmwtr} =$_[0]->{-racAdmWtr} && ugmember($_[0], $_[0]->{-racAdmWtr})
}


sub uadmrdr {	# user admin reader groups membership
 return($_[0]->{-c}->{-uadmrdr}) if exists($_[0]->{-c}->{-uadmrdr});
 $_[0]->{-c}->{-uadmrdr} =$_[0]->{-racAdmRdr} && ugmember($_[0], $_[0]->{-racAdmRdr})
}


sub uglist {	# User & Group List
 my $s =shift;	# self, -opt, ?user|group|filter, ?container
 my $o =defined($_[0]) && substr($_[0],0,1) eq '-' ? shift : '-ug';
 my $fc=ref($_[0]) eq 'CODE' ? shift : undef;
 my $fm=ref($_[0]) ? undef : $_[0] && $o !~/u/ ? [map {lc($_)} @{$s->ugroups(shift)}] : shift;
 my $fg=$s->{-ugflt};
 my $fu=$s->{-unflt};
 my $r =shift ||[];
 my $fn=undef;
 local $_;
 if	($s->{-uglist}) {
	$r =&{$s->{-uglist}}($s, $o, $r)
 }
 elsif	($s->{-AuthUserFile} ||$s->{-AuthGroupFile}) {
	my @r;
	my $en;
	$fn =$s->{-AuthGroupFile};
	if ($fm && !ref($fm) && -f $fn) {
		my $fh=$s->hfNew('<', $fn)->lock(LOCK_SH);
		while(my $r =$fh->readline()) {
			next if $r !~/^\Q$fm\E:/i;
			$r =$'; chomp($r);
			$fm =[map {lc($_)} split /[\t]+/, $r];
			last;
		}
		$fh->close()
	}
	$fm =undef if $fm && (!ref($fm) || !@$fm);
	$fn =$s->{-AuthUserFile};
	if ($o =~/u/ && $fn && -f $fn) {
		my $fh=$s->hfNew('<', $fn)->lock(LOCK_SH);
		while(my $r =$fh->readline()) {
			next if $r !~/^([^:]+):/;
			$en =$_ =$1;
			next	if $fu && !&$fu($s,$en)
				|| $fc && !&$fc($s,$en);
			if	($fm) {
				my($el, $rl) =(lc($en), undef);
				foreach my $e (@$fm) {if ($el eq $e) {$rl =$el; last}};
				next if !$rl;
			}
			push @r, $en;
		}
		$fh->close()
	}
	$fn =$s->{-AuthGroupFile};
	if ($o =~/g/ && $fn && -f $fn) {
		my $fh=$s->hfNew('<', $fn)->lock(LOCK_SH);
		while(my $r =$fh->readline()) {
			next if $r !~/^([^:]+):/;
			$en =$_ =$1;
			next	if $fg && !&$fg($s,$en)
				|| $fc && !&$fc($s,$en);
			if	($fm) {
				my($el, $rl) =(lc($en), undef);
				foreach my $e (@$fm) {if ($el eq $e) {$rl =$el; last}};
				next if !$rl;
			}
			push @r, $en;
		}
		$fh->close()
	}
	$r =ref($r) eq 'HASH'
		? {map {($_ => $_)} @r}
		: [@r]
 }
 elsif	($^O eq 'MSWin32'
	&& $s->w32agf()
	&& ($fn =$s->pthForm('var','ualist'))
	&& -f $fn) {
	my $dn=!$s->{-userln} && $s->w32domain();
	if ($fm && !ref($fm)) {
		my $fn=$s->pthForm('var','uagroup');
		my $vn=!$dn
			? $fm
			: $fm =~/^\Q$dn\E\\/i
			? $'
			: $fm =~/\@\Q$dn\E$/i
			? $`
			: $fm;
		if (-f $fn) {
			my $fh=$s->hfNew('<', $fn)->lock(LOCK_SH);
			while(my $rr =$fh->readline()) {
				next if $rr !~/^\Q$vn\E:/i;
				$rr =$'; chomp($rr);
				$fm =[map {lc($_)} split /[\t]+/, $rr];
				last;
			}
			$fh->close()
		}
		$fm =undef if $fm && (!ref($fm) || !@$fm);
	}
	my $fh=$s->hfNew('<', $fn)->lock(LOCK_SH);
	while(my $rr =$fh->readline()) {
		my ($en, $ef, $ep, $ec, $ed) =(split /:\t/, $rr)[0,1,2,3,4];
		if	($fc) {next if !&$fc($s, $en, $ef, $ep, $ed)}
		elsif	($fm) {
			my($el, $rl) =(lc($en), undef);
			foreach my $e (@$fm) {if ($el eq $e) {$rl =$el; last}};
			next if !$rl;
		}
		$en =$s->{-usernt}
			? ($en =~/^([^\@]+)\@([^\@]+)$/ ? "$2\\$1" : $dn ? "$dn\\$en" : $en)
			: ($en =~/^([^\\]+)\\([^\\]+)$/ ? "$2\@$1" : $dn ? "$en\@$dn" : $en);
		my $ev =($en =~/[\@\\]/ && $o !~/[<>]/ ? $ef : $en);
		$_ =$en;
		if ($o =~/g/ && $ec =~/^g/i) {
			next if $fg && !&$fg($s, $en, $ef, $ep, $ed);
			if (ref($r) eq 'ARRAY') {
				push(@$r, $en)
			}
			else {
				$r->{$en} =!$ed
					? $ev
					: $o =~/[<>]/
					? (length($ed)+length($ev)+3 >60 
						? substr($ed, 0, 60 -length($ev)-6) .'...' 
						: $ed) 
					  .' <' .$ev .'>'
					: $ed =~/^\Q$en\E\s*([,-:]*)\s*(.*)/i
					? $ev .($1 ? " $1 " : ' - ') .$2
					: "$ev, $ed"
			}
		}
		if ($o =~/u/ && $ec =~/^u/i) {
			next if $fu && !&$fu($s, $en, $ef, $ep, $ed);
			if (ref($r) eq 'ARRAY') {
				push(@$r, $en)
			}
			else {
				$r->{$en} =$ed .' <' .$ev .'>'
			}
		}
	}
	$fh->close();
 }
 else {
 }
 $r =do{use locale; [sort {lc($a) cmp lc($b)} @$r]} if ref($r) eq 'ARRAY';
 $r
}


sub udisp {	# display user name
 !defined($_[1]) || $_[1] eq ''
 ? ''
 : $_[0]->{-AuthUserFile}
 ? $_[1]
#: $^O ne 'MSWin32' ? $_[1]
 : (($_[0]->{-c}->{-udisp} ||($_[0]->{-c}->{-udisp} =uglist($_[0], '-u', {}))
	)->{$_[1]} ||(($^O eq 'MSWin32') && w32udisp(@_)) ||$_[1])
}


sub w32IISdpsn {# deimpersonate Microsoft IIS impersonated process
		# !!!Future: Problems may be. Implement '-fswtr' login also?
		# 'Win32::API' used.
		# Set 'IIS / Home Directory / Application Protection' = 'Low (IIS Process)'
		# or see 'Administrative Tools / Component Services'.
		# Do not use quering to 'Index Server'.
		# See also FastCGI for another ways:
		# http://php.weblogs.com/fastcgi_with_php_and_iis
		# http://www.caraveo.com/fastcgi/
		# http://www.cpan.org/modules/by-module/FCGI/
 return(undef)	if $^O ne 'MSWin32'
		|| !(($ENV{SERVER_SOFTWARE}||'') =~/IIS/)
		|| !$ENV{REMOTE_USER}
		|| $ENV{'GATEWAY_INTERFACE'}
		|| $ENV{'FCGI_SERVER_VERSION'}
		|| $_[0]->{-c}->{-RevertToSelf};
 $_[0]->user();
 $_[0]->{-c}->{-RevertToSelf} =1;
 my $o =eval('use Win32::API; new Win32::API("advapi32.dll","RevertToSelf",[],"N")');
 $o	? $o->Call()
	: &{$_[0]->{-die}}($_[0]->lng(0, 'w32IISdpsn') .": Win32::API('RevertToSelf') -> $@")
}


sub w32adhi {	# Win32 AD Host Info
 $_[0]->{'ADSystemInfo'} 
 || ($_[0]->{'ADSystemInfo'} =eval('use Win32::OLE; Win32::OLE->Option("Warn"=>0); Win32::OLE->CreateObject("ADSystemInfo")'))
}


sub w32domain {	# Win32 domain name (or node name if no domain)
 w32adhi($_[0])->{DomainShortName} || eval{Win32::NodeName()} || $ENV{COMPUTERNAME}
}


sub w32agf {	# Win32 Apache 'AuthGroupFile' write/refresh
 return(undef) if $^O ne 'MSWin32';
 my $s  =$_[0];						# self object
 my $fs =$_[1] ||$s->pthForm('var');			# filesystem
 my $mo =$_[2];						# mandatory operation
 my $df =$_[3] ||$s->{-udflt} ||sub{1};			# domain filter
 my $fg =$fs .'/' .'uagroup';				# file 'group'
 my $fl =$fs .'/' .'ualist';				# file list
 return(1) 						# update frequency
	if (-f $fg)
	&& (time() -[stat($fg)]->[9] <60*60);
 if (!$mo) {						# check mode
	if (!-f $fg) {			# immediate interactive
		$s->logRec('w32agf','new',$fg);
	}
	elsif ($mo =$s && $s->{-endh}) {# end request handlers
		$s->logRec('w32agf','queue','uagroup',stat($fg)) if !$mo->{w32agf};
		$mo->{w32agf} =sub{w32agf($_[0],$fs,'q',$df)};
		return(1)
	}
 }
 elsif ($mo eq 'q') {					# queued mode
	if (1) {			# inline
	}
	elsif (eval("use Thread; 1")	# threads
	&& ($mo =eval{Thread->new(sub{w32agf(undef,$fs,'t',$df)})})
		) {
		$s->logRec('w32agf','thread',$mo);
		$mo->detach;
		return(1);
	}
	elsif ($mo =fork) {		# fork parent success
		$SIG{CHLD} ='IGNORE';
		$s->logRec('w32agf','fork',$mo);
		return(1);
	}
	elsif (!defined($mo)) {		# fork error, immediate interactive
	}
	else {				# fork child
		$mo ='f';
		w32agf(undef,$fs,$mo,$df);
		exit(0);
	}
 }
 my @tm=(time());
 local(*FG, *FL, *FW);
 open(FG, "+>>$fg.tmp")
	|| ($s && &{$s->{-die}}($s->lng(0, 'w32agf') .": open('$fg.tmp') -> $!"))
	|| croak("open('<$fg.tmp') -> $!");
 open(FL, "+>>$fl.tmp")
	|| ($s && &{$s->{-die}}($s->lng(0, 'w32agf') .": open('$fl.tmp') -> $!"))
	|| croak("open('<$fl.tmp') -> $!");
 while (!flock(FG,LOCK_EX|LOCK_NB) ||!flock(FL,LOCK_EX|LOCK_NB)) {
	next if !-f $fg;
	flock(FG,LOCK_UN); close(FG);
	flock(FL,LOCK_UN); close(FL);
	return(1)
 }
 truncate(FG,0); truncate(FL,0);
 seek(FG,0,0); seek(FL,0,0);
 eval('use Win32::OLE'); Win32::OLE->Option('Warn'=>0);
 my $od =Win32::OLE->GetObject('WinNT://' .(Win32::NodeName()) .',computer');
 my $hdu=$od	&& $od->{Name}		|| ''; 		# host domain name
 my $hdn=$od	&& lc($od->{Name})	|| ''; 		# host domain name
 my $hdp=$od	&& $od->{ADsPath}	|| '';		# host domain path
 my $hdc=lc($hdp);					# host domain comparable
 my $ldp=$od	&& $od->{Parent}	|| '';		# local domain path
    $od =Win32::OLE->GetObject("$ldp,domain");
 my $ldu=$od	&& $od->{Name}		|| '';		# local domain name
 my $ldn=$od	&& lc($od->{Name})	|| '';		# local domain name
 my $ldc=lc($ldp);					# local domain comparable
 $s->logRec('w32agf','host',$hdp,'domain',$ldp)
	if $s;
 my %dnl=(!$hdn ?() :($hdn=>1), !$ldn ?() :($ldn=>1));	# domains to list
 my @dnl=(!$hdu ?() :$hdu, !$ldu ?() :$ldu);		# domains to list
 my $fgm;						# group lister/unfolder
    $fgm=sub{	my $om =$_[1]->{Members};
		join("\t"
		,(map {!$_ || !$_->{Class} || !$_->{Name} || substr($_->{Name},-1,1) eq '$' || substr($_->{Name},-1,1) eq '&'
		? ()
		: do {	my $dn =$_->{Parent} =~/([^\\\/]+)$/ ? $1 : $_->{Parent};
			map {$_ # $_ ne lc($_) ? ($_, lc($_)) : $_
				} lc($_->{Parent}) ne ($ldn ? $ldc : $hdc)
				? ($dn . '\\' .$_->{Name})
				: ($_->{Name}, ($dn . '\\' .$_->{Name}))
				, $_->{Name} .'@' .$dn
			}} do {$om->{Filter} =['User']; Win32::OLE::in($om)})
		,(map {!$_ || !$_->{Class} || !$_->{Name} || !$_->{groupType} || substr($_->{Name},-1,1) eq '$' || substr($_->{Name},-1,1) eq '&'
		? ()
		: do {	if ($_->{groupType} eq '2') {
				my $du =$_->{Parent} =~/([^\\\/]+)$/ ? $1 : $_->{Parent};
				my $dn =lc($du);
				if (!$dnl{$dn} && $dn !~/^(?:nt authority|builtin)$/) {
					$dnl{$dn} =1;
					push @dnl, $du;
				}
			}
			(&$fgm($_[0], $_))
			}} do {$om->{Filter} =['Group']; Win32::OLE::in($om)})
		)};
 for (my $di =0; $di <=$#dnl; $di++) {
	my $du =$dnl[$di];
	local $_ =$du;
	next if !$du ||!&$df($s, $du);
	push @tm, time();
	$s->logRec('w32agf','domain',$du) if $s;
	my $dn =lc($du);
	$od =Win32::OLE->GetObject("WinNT://$du");
	next if !$od || !$od->{Class};
	# standalone host:	local users, local groups
	# domain member	:	domain users, local groups, domain groups
	# domain controller:	domain users, local groups, domain groups
	my $dp =$dn eq $ldn || $dn eq $hdn ? '' : $du;
	unless ($hdn && $ldn && ($dn eq $hdn)) {
		$od->{Filter} =['User'];
		foreach my $oe (Win32::OLE::in($od)) {
			next if !$oe || !$oe->{Class} || !$oe->{Name} || substr($oe->{Name},-1,1) eq '$' || substr($oe->{Name},-1,1) eq '&';
			next if $oe->{AccountDisabled};
			next if $oe->{Name} =~/^(?:SYSTEM|INTERACTIVE|NETWORK|IUSR_|IWAM_|HP ITO |opc_op|patrol|SMS |SMS&_|SMSClient|SMSServer|SMSService|SMSSvc|SMSLogon|SMSInternal|SMS Site|SQLDebugger|sqlov|SharePoint|RTCService)/i;
			print FL $dp ? "$dp\\" : '', $oe->{Name}
			,":\t", $oe->{Name} .'@' .$du
			,":\t", $oe->{ADsPath}
			,":\t", $oe->{Class}
			,":\t", $oe->{FullName}||($oe->{Name} .'@' .$du)
			,":\t", $oe->{Description}||''
			, "\n";
		}
	}
	unless (0) {
		$od->{Filter} =['Group'];
		foreach my $oe (Win32::OLE::in($od)) {
			next if !$oe || !$oe->{Class} || !$oe->{Name} || substr($oe->{Name},-1,1) eq '$' || substr($oe->{Name},-1,1) eq '&';
			next	if	$dn ne $hdn
				?	$oe->{groupType} ne '2'  # global
				:	$oe->{groupType} ne '4'; # local
			next if $oe->{Name} =~/^(?:Domain Controllers|Domain Computers|Pre-Windows 2000|RAS and IAS Servers|MTS Trusted|SMSInternal|NetOp Activity)/i;
			my $sgm =&$fgm($_[0], $oe);
			print FL $dp ? "$dp\\" : '', $oe->{Name}
			,":\t", $oe->{Name} .'@' .$du
			,":\t", $oe->{ADsPath}
			,":\t", $oe->{Class}
			,":\t", $oe->{Description}||($oe->{Name} .'@' .$du)
			,":\t", $oe->{Description}||''
			,":\t", $sgm
			, "\n";
			print FG !$dp ? ($oe->{Name}, ":\t", $sgm, "\n") : ()
			, $du, '\\', $oe->{Name}, ":\t", $sgm, "\n"
			, $oe->{Name}, '@', $du, ":\t", $sgm, "\n"
			;
		}
	}
 }
 seek(FG,0,0); seek(FL,0,0);
 open(FW, "+>>$fg") && flock(FW,LOCK_EX)
 	&& truncate(FW,0) && seek(FW,0,0)
	&& do {while(my $rr =readline *FG){print FW $rr}; 1}
	&& flock(FW,LOCK_UN) && close(FW)
	|| ($s && $s->die($s->lng(0, 'w32agf') .": open('$fg') -> $!"))
	|| croak("open('<$fg') -> $!");
 flock(FG,LOCK_UN); close(FG); unlink("$fg.tmp");
 open(FW, "+>>$fl") && flock(FW,LOCK_EX) 
 	&& truncate(FW,0) && seek(FW,0,0)
	&& do {while(my $rr =readline *FL){print FW $rr}; 1}
	&& flock(FW,LOCK_UN) && close(FW)
	|| ($s && $s->die($s->lng(0, 'w32agf') .": open('$fl') -> $!"))
	|| croak("open('<$fl') -> $!");
 flock(FL,LOCK_UN); close(FL); unlink("$fl.tmp");
 push @tm, time();
 $s->logRec('w32agf','timing',join('-', map {$tm[$_] -$tm[$_-1]} (1..$#tm)),'sec')
	if $s;
 1;
}


sub w32user {	# Win32 user object
	eval('use Win32::OLE; Win32::OLE->Option("Warn"=>0)');
	my ($dn, $gn) =	$_[1] =~/^([^\\]+)\\(.+)/ 
			? ($1,$2) 
			: $_[1] =~/^([^@]+)@(.+)/ 
			? ($2,$1) 
			: (Win32::NodeName(),$_);
	Win32::OLE->GetObject("WinNT://$dn/$gn");
}


sub w32udisp {	# Win32 user display name
	return($_[1]) if $^O ne 'MSWin32';
	my ($dn, $gn) =	$_[1] =~/^([^\\]+)\\(.+)/ 
			? ($1,$2) 
			: $_[1] =~/^([^@]+)@(.+)/ 
			? ($2,$1) 
			: (Win32::NodeName(),$_);
	my $o =eval('use Win32::OLE; Win32::OLE->Option("Warn"=>0); 1')
		&& Win32::OLE->GetObject("WinNT://$dn/$gn");
	!$o
	? $_[1]
	: $o->{Class} eq 'User'
	? $o->{FullName} ||$_[1]
#	: $o->{Class} eq 'Group'
#	? $o->{Description} ||$_[1]
	: $_[1]
}


sub w32ugrps {	# Win32 user groups, optional usage, interesting legacy code
 my $uif =$_[1];		# user input full name
 my $uid ='';			# user input domain name
 my $uin ='';			# user input name shorten
 eval('use Win32::OLE'); Win32::OLE->Option('Warn'=>0);
 if	($uif =~/^([^\\]+)\\(.+)/)	{ $uid =$1;	$uin =$2 }
 elsif	($uif =~/^([^@]+)\@(.+)/)	{ $uid =$2;	$uin =$1 }
 else					{ $uin =$uif;	$uid =Win32::OLE->CreateObject('ADSystemInfo')->{DomainShortName} ||Win32::NodeName()}
 my $gn =[];			# group names
 my $gp =[];			# group paths
 my $oh =Win32::OLE->GetObject('WinNT://' .Win32::NodeName() .',computer');
 return($gn) if !$oh;
 my $ou =Win32::OLE->GetObject("WinNT://$uid/$uin,user");
 return($gn) if !$ou;
 my $dp =			# domain prefix for global groups, optional
	  lc($oh->{Parent}) eq lc($ou->{Parent})
	? ''
	: $ou->{Parent} =~/([^\\\/]+)$/
	? $1 .'\\'
	: '';
 foreach my $og (Win32::OLE::in($ou->{Groups})) { # global groups from user's domain
	next if !$og || !$og->{Class} || $og->{groupType} ne '2';
	push @$gn, $dp .$og->{Name};
	push @$gp, $og->{ADsPath};
 }
 my $uc =lc($ou->{ADsPath});	# user compare
 my $gc =[map {lc($_)} @$gp];	# group compare
 $oh->{Filter} =['Group'];
 foreach my $og (Win32::OLE::in($oh)) {
	next if !$og || !$og->{Class} || $og->{groupType} ne '4';
	foreach my $om (Win32::OLE::in($og->{Members})) {
		next if !$om || !$om->{Class} || ($om->{Class} ne 'User' && $om->{Class} ne 'Group');
		my $mc =lc($om->{ADsPath});
		foreach my $p (@$gc) {
			next if $p ne $mc;
			push @$gn, $og->{Name};
			push @$gp, $og->{ADsPath};
			$mc =undef;
			last;
		}
		last if !$mc;
		if ($mc eq $uc) {
			push @$gn, $og->{Name};
			push @$gp, $og->{ADsPath};
			last;
		}
	}
 }
 $gn;
}


#########################################################
# Database methods
#########################################################


sub mdeTable {	# Table MetaData Element
		# (self, table name) -> table metadata
						# Cached
 return	($_[0]->{-table}->{$_[1]})
	if $_[0]->{-table}->{$_[1]}
	&& $_[0]->{-table}->{$_[1]}->{'.mdeTable'};

 my ($s, $tn) =@_;
						# Generate table
						# table factory may be developed
 &{$s->{-mdeTable}}($s, $tn)
	if $s->{-mdeTable} && !$s->{-table}->{$tn};
 return	(&{$s->{-die}}('mdeTable(' .$tn .') -> not described table'))
	if !$s->{-table}->{$tn};
						# Organize table metadata
 $s->logRec('mdeTable', $tn);
 my $tm =$s->{-table}->{$tn};
 $tm->{'.mdeTable'} =1;				# flag of organized
 $tm->{-mdefld} ={};				# hash of fields
 if (ref($tm->{-field}) eq 'ARRAY') {
	foreach my $f (@{$tm->{-field}}) {	# field flags setup
		next if !ref($f) ||ref($f) ne 'HASH';
		$tm->{-mdefld}->{$f->{-fld}} =$f
			if $f->{-fld};
		$f->{-flg} ='a'			# 'a'll
			if !exists($f->{-flg});
		if ($f->{-flg} =~/k/) {
			if (!$tm->{-key}) {	# 'k'ey
				$tm->{-key} =[$f->{-fld}]
			}
			elsif (!grep {$_ eq $f->{-fld}} @{$tm->{-key}}) {
				push @{$tm->{-key}}, $f->{-fld}
			}
		}
		if ($f->{-flg} =~/w/) {		# 'w'here
			if (!$tm->{-wkey}) {
				$tm->{-wkey} =[$f->{-fld}]
			}
			elsif (!grep {$_ eq $f->{-fld}} @{$tm->{-wkey}}) {
				push @{$tm->{-wkey}}, $f->{-fld}
			}
		}
		$f->{-flg} ='w' .$f->{-flg}	# 'w'here
			if $f->{-flg} !~/w/ && $tm->{-wkey} && grep {$_ eq $f->{-fld}} @{$tm->{-wkey}};
		$f->{-flg} ='k' .$f->{-flg}	# 'k'ey
			if $f->{-flg} !~/k/ && $tm->{-key} && grep {$_ eq $f->{-fld}} @{$tm->{-key}};
		$f->{-flg}.='e'			# 'e'dit
			if $f->{-flg} !~/e/ && $f->{-edit};
	 }
 }
 $tm
}


sub mdlTable {	# Tables List
 sort(	  $_[0]->{-mdlTable}
	?(keys %{$_[0]->{-table}}
		, grep {!$_[0]->{-table}->{$_}} &{$_[0]->{-mdlTable}})
	: keys %{$_[0]->{-table}})
}


sub mdeQuote {	# Quote field value if needed
		# self, table, field, value
  my $t =ref($_[1]) eq 'HASH' ? $_[1] : mdeTable($_[0], !ref($_[1]) ? $_[1] : ref($_[1]->[0]) ? $_[1]->[0]->[0] : $_[1]->[0]);
    !ref($t) || !$t->{-mdefld} || !$t->{-mdefld}->{$_[2]} || !$t->{-mdefld}->{$_[2]}->{-flg}
  ? (	  !defined($_[3])
	? 'NULL'
	: ($_[3] =~/\d+/) && ($_[3] =~/^[\d.,\s]+$/)
	? $_[3]
	: !$_[0]->{-dbi}
	? strquot($_[0], $_[3])
	: $_[0]->{-dbi}->quote($_[3])
	)
  : $t->{-mdefld}->{$_[2]}->{-flg} =~/["']/
  ? (!$_[0]->{-dbi} ? strquot($_[0], $_[3]) : $_[0]->{-dbi}->quote($_[3]))
  : $t->{-mdefld}->{$_[2]}->{-flg} =~/[9n]/
  ? $_[3]
  : !defined($_[3])
  ? 'NULL'
  : ($_[3] =~/\d/) && ($_[3] =~/^[\d.,\s]+$/)
  ? $_[3]
  : !$_[0]->{-dbi}
  ? strquot($_[0], $_[3])
  : $_[0]->{-dbi}->quote($_[3])
}


sub mdeReaders {# Table readers fields
		# self, table
 my $r =!$_[0]->{-rac} || $_[0]->uadmrdr()
 ?      undef
 :	ref($_[1])
 ?	[@{$_[1]->{-racReader} ||$_[0]->{-racReader} ||[]}
	,@{$_[1]->{-racWriter} ||$_[0]->{-racWriter} ||[]}]
 :	[@{$_[0]->{-table}->{$_[1]}->{-racReader} ||$_[0]->{-racReader}||[]}
	,@{$_[0]->{-table}->{$_[1]}->{-racWriter} ||$_[0]->{-racWriter}||[]}];
#$_[0]->logRec('mdeReaders',@_[1..$#_],$r);
 ref($r) && @$r ? $r : undef
}


sub mdeWriters {# Table writers fields
		# self, table
 	!$_[0]->{-rac} || $_[0]->uadmwtr()
 ?      undef
 :	ref($_[1])
 ?	$_[1]->{-racWriter} ||$_[0]->{-racWriter} ||undef
 :	$_[0]->{-table}->{$_[1]}->{-racWriter} ||$_[0]->{-racWriter} ||undef
}


sub mdeRAC {	# Table record access control condition
		# self, table/form, ? option switch
 if ($_[2]) {
	my $m =ref($_[1]) ? $_[1] : ($_[0]->{-form}->{$_[1]} ||$_[0]->{-table}->{$_[1]} ||{});
	return(undef) if exists($m->{$_[2]}) && !$m->{$_[2]};
 }
 my $m =(ref($_[1])
	? ($_[1]->{-table} ? $_[0]->{-table}->{$_[1]->{-table}} : $_[1])
	:  $_[0]->{-form}->{$_[1]}
	? ($_[0]->{-form}->{$_[1]}->{-table} ? $_[0]->{-table}->{$_[0]->{-form}->{$_[1]}->{-table}} : $_[0]->{-form}->{$_[1]})
	:  $_[0]->{-table}->{$_[1]}
	) ||{};
	( $m->{-racPrincipal}	||$_[0]->{-racPrincipal}
	||$m->{-racUser}	||$_[0]->{-racUser}
	||$m->{-racActor}	||$_[0]->{-racActor} 
	||$m->{-racWriter}	||$_[0]->{-racWriter} 
	||$m->{-rvcUpdBy}	||$_[0]->{-rvcUpdBy}
	) && $m
}


sub mdeRole {	# Table user role fields list
		# self, table, role, ? altrole
 my $m =ref($_[1]) ? $_[1] : $_[0]->{-table}->{$_[1]};
 my $r =$_[2] eq 'all'
 ?	undef
 :	$_[2] eq 'creator'
 ?	[$m->{-rvcInsBy} ||$_[0]->{-rvcInsBy} ||()]
 :	$_[2] eq 'updater'
 ?	[$m->{-rvcUpdBy} ||$_[0]->{-rvcUpdBy} ||()]
 :	$_[2] eq 'author'
 ?	[$m->{-rvcInsBy} ||$_[0]->{-rvcInsBy} ||()
	,$m->{-rvcUpdBy} ||$_[0]->{-rvcUpdBy} ||()]
 :	$_[2] eq 'authors'
 ?	$m->{-racWriter} ||$_[0]->{-racWriter} 
		|| mdeRole($_[0], $m, $_[3] ||'author')
 :      $_[2] eq 'actor'
 ?	$m->{-racActor} &&[$m->{-racActor}->[0]] 
		|| $_[0]->{-racActor} &&[$_[0]->{-racActor}->[0]] 
		||mdeRole($_[0], $m, $_[3] ||'actors')
 :	$_[2] eq 'actors'
 ?	$m->{-racActor} ||$_[0]->{-racActor} 
		|| ($_[3] ? mdeRole($_[0], $m, $_[3]) : undef)
		|| ($m->{-rvcUpdBy}	&& [$m->{-rvcUpdBy}])
		|| ($_[0]->{-rvcUpdBy}	&& [$_[0]->{-rvcUpdBy}])
		|| mdeRole($_[0], $m, 'authors')
 :      $_[2] eq 'principal'
 ?	$m->{-racPrincipal} &&[$m->{-racPrincipal}->[0]] 
		|| $_[0]->{-racPrincipal} &&[$_[0]->{-racPrincipal}->[0]] 
		|| mdeRole($_[0], $m, $_[3] ||'principals')
 :	$_[2] eq 'principals'
 ?	$m->{-racPrincipal} ||$_[0]->{-racPrincipal}
		|| ($_[3] ? mdeRole($_[0], $m, $_[3]) : undef)
		|| ($m->{-rvcInsBy}	&& [$m->{-rvcInsBy}])
		|| ($_[0]->{-rvcInsBy}	&& [$_[0]->{-rvcInsBy}])
		|| mdeRole($_[0], $m, 'author')
 :      $_[2] eq 'user'
 ?	$m->{-racUser} &&[$m->{-racUser}->[0]] 
		|| $_[0]->{-racUser} &&[$_[0]->{-racUser}->[0]] 
		|| mdeRole($_[0], $m, $_[3] ||'users')
 :	$_[2] eq 'users'
 ?	$m->{-racUser} ||$_[0]->{-racUser}
		|| mdeRole($_[0], $m, $_[3] ||'principals')
 :	mdeRole($_[0], $m, 'authors');
 ref($r) && @$r ? $r : undef
}


sub mdeRoles {	# Table user roles list
		# self, table/form ||0, ? pass value
 return(qw(all author authors actor actors principal principals user users)) if !$_[1];
 my $m =!$_[1] ? $_[1] : (mdeRAC(@_) ||{});
 my @l =('all'
	#,!$m ||$m->{-rvcInsBy}	||$_[0]->{-rvcInsBy}	? ('creator')	: ()
	#,!$m ||$m->{-rvcUpdBy}	||$_[0]->{-rvcUpdBy}	? ('updater')	: ()
	,!$m ||$m->{-rvcInsBy}	||$_[0]->{-rvcInsBy}	||
	 !$m ||$m->{-rvcUpdBy}	||$_[0]->{-rvcUpdBy}	? ('author')	: ()
	,!$m ||$m->{-racWriter}	||$_[0]->{-racWriter}	? ('authors')	: ()
	,!$m ||$m->{-racActor}	||$_[0]->{-racActor}	? ('actor','actors')	: ()
	,!$m ||$m->{-racPrincipal}	||$_[0]->{-racPrincipal} ? ('principal','principals') : ()
	,!$m ||$m->{-racUser}	||$_[0]->{-racUser}	? ('user','users') : ()
	);
 push @l, $_[2] if $_[2] && !grep {$_ eq $_[2]} @l;
 @l
}


sub mdeFldIU {	# Field of Inserters/Updaters
    $_[2]	# self, table meta, field
&&(($_[1]->{-rvcInsBy} && ($_[1]->{-rvcInsBy} eq $_[2]))
|| ($_[0]->{-rvcInsBy} && ($_[0]->{-rvcInsBy} eq $_[2]))
|| ($_[1]->{-rvcUpdBy} && ($_[1]->{-rvcUpdBy} eq $_[2]))
|| ($_[0]->{-rvcUpdBy} && ($_[0]->{-rvcUpdBy} eq $_[2])))
}


sub mdeFldRW {	# Field of Readers/Writers
		# self, table meta, field
 return(undef)	if !$_[2] 
		|| !($_[1]->{-racReader} ||$_[0]->{-racReader} ||$_[1]->{-racWriter} ||$_[0]->{-racWriter});
 foreach my $e (  $_[1]->{-racReader} ? @{$_[1]->{-racReader}} : $_[0]->{-racReader} ? @{$_[0]->{-racReader}} : ()
		, $_[1]->{-racWriter} ? @{$_[1]->{-racWriter}} : $_[0]->{-racWriter} ? @{$_[0]->{-racWriter}} : ()) {
	return($_[2]) if $e eq $_[2]
 }
 return(undef)
}


sub recType {   # Record type or table name
 $_[1]->{-table}
 || ($_[1]->{-form} && $_[0]->{-form}->{$_[1]->{-form}} && $_[0]->{-form}->{$_[1]->{-form}}->{-table})
 || (ref($_[2]) ne 'HASH' && substr($_[2], 0, index($_[2],'='))) # class name
}


sub recFields { # Field names in the record hash
		# !!! sort degradation
 sort grep {substr($_,0,1) ne '-' && substr($_,0,1) ne '.'} keys %{$_[1]}
}


sub recValues { # Field values in the record hash
 map {$_[1]->{$_}} recFields($_[0], $_[1])
}


sub recData {   # Field name => value hash ref
 return({map {($_=> $_[1]->{$_})} recFields($_[0], $_[1])})
}


sub recKey {	# Record's key: field => value hash ref
		# self, table name, record
 my $m =$_[0]->{-table}->{$_[1]} ||$_[0]->{-form}->{$_[1]};
   $m && $m->{-key}
 ? {map {($_=>$_[2]->{$_})}  @{$m->{-key}}}
 : $_[2]->{'id'}		# 'id' field present
 ? {'id'=>$_[2]->{'id'}}
 : {}
}


sub recWKey {	# Record's optimistic key: field => value hash ref
		# self, table name, record
 my $m =$_[0]->{-form}->{$_[1]} ||$_[0]->{-table}->{$_[1]};
 return(recKey(@_)) if !$m;
 my $r ={};
 if	($m->{-wkey}) {
	$r ={map {($_=>$_[2]->{$_})
		}  grep {defined($_[2]->{$_})
			} @{$m->{-wkey}}}
 }
 %$r ? $r : recKey(@_)
}


sub rmlClause { # Command clause words and values list from record's hash ref
		# (record manipulation language)
		# !!! sort degradation
 map {($_=>$_[1]->{$_})} sort grep {substr($_,0,1) eq '-'} keys %{$_[1]}
}


sub rmlKey {  # Record's '-key' clause value
                # ($self, {command}, {data})
   $_[1]->{-key} && !ref($_[1]->{-key})		# should be translated
 ? {'id'=>rmlIdSplit(@_[0,1],$_[1]->{-key})}
 : $_[1]->{-key}				# already exists
 ? $_[1]->{-key}
 : $_[1]->{-where}				# not needed using '-where'
 ? $_[1]->{-key}
 : $_[0]->{-table}->{$_[1]->{-table}}->{-key}	# key described
 ? {(map {($_=>$_[2]->{$_})} 
	@{$_[0]->{-table}{$_[1]->{-table}}->{-key}})}
 : $_[2]->{'id'}				# 'id' field present
 ? {'id'=>rmlIdSplit(@_[0,1],$_[2]->{'id'})}
 : undef
}


sub rmlIdSplit {# Split record ID into table name and real ID
		# ($self, {command}, key value)
  !$_[0]->{-idsplit} 
 ? $_[2]
 : ref($_[0]->{-idsplit}) 
 ? &{$_[0]->{-idsplit}}(@_)
 : $_[2] =~m/([^\Q$RISM0\E]+)\Q$RISM1\E((?:.(?!\Q$RISM1\E))+)$/
	# !!! optimize: 'database $RISM0 table $RISM1 rowid'
 ? eval{$_[1]->{-table}=$1; $2}	# 'table//rowid', table !~m!/!, rowid !~m!//!
 : $_[2]
}


sub rmiTrigger {# Execute trigger
		# (record manipulation internal)
                # self, {command}, {data}, {record}, trigger names
 local $_[0]->{-affect}	=undef;
 local $_[0]->{-rac}	=undef;
 my $tbl =$_[0]->{-table}->{$_[1]->{-table}};
 my $frm =$_[0]->{-form}->{$_[1]->{-form}} if $_[1]->{-form} && $_[0]->{-form};
 foreach my $t (@_[4..$#_]) {
	&{$_[0]->{$t}}($_[0], $_[1], $_[2], $_[3]) if $_[0]->{$t} && !($t eq '-recInsID' && $tbl->{$t});
	&{$tbl->{$t}} ($_[0], $_[1], $_[2], $_[3]) if $tbl->{$t};
	&{$frm->{$t}} ($_[0], $_[1], $_[2], $_[3]) if $frm && $frm->{$t} && ($frm->{$t} ne $tbl->{$t});
 }
 $_[0]
}


sub rmiIndex {  # Index record
		# {-table=>name}, {newData=>value}, {oldData=>value}
 my ($s, $a, $d, $r) =@_;
 my  $n =$d; # {%$r} ||{}; @{$n}{keys %$d} =values %$d;
 my  @q =([undef,'-'],[undef,'+']);
 local $s->{-affect}	=undef;
 local $s->{-rac}	=undef;
 if (my $m =$s->{-table}->{$a->{-table}}->{-recIndex0R}) {
	&$m($s, $a, $d, $r)
 }
 foreach my $x (keys %{$s->{-table}}) {
	next if !ref($s->{-table}->{$x}->{-ixcnd});
	my $i =$s->{-table}->{$x};
	$q[0]->[0] =$r && &{$i->{-ixcnd}}($s, $a, $r) ? $r : 0; # delete
	$q[1]->[0] =$d && &{$i->{-ixcnd}}($s, $a, $n) ? $n : 0; # insert/update
	foreach my $q (@q) {
		next if !$q->[0];
		my $v =	  $i->{-ixrec} 
			? &{$i->{-ixrec}}($s, $a, $q->[0], $q->[1])
			: $i->{-field} && ref($i->{-field}) eq 'ARRAY'
			? {map {$q->[0]->{$_}} grep {ref($_) && $_->{-fld}} @{$i->{-field}}}
			: $i->{-field} && ref($i->{-field}) eq 'HASH'
			? {map {$q->[0]->{$_}} keys %{$i->{-field}}}
			: undef;
		foreach my $r (!ref($v) ? () : ref($v) eq 'ARRAY' ? @$v : ($v)) {
			my $k =rmlKey($s, {-table=>$x}, $r);
			$q->[1] eq '-'
			? $s->dbiDel({-table=>$x, -key=>$k}, $r)
			: $s->dbiUpd({-table=>$x, -key=>$k, -save=>1}, $r);
		}
	}
 }
 $d
}


sub recIndex {	# Update/delete index entry, for calls from '-recIndex0R'
		# index name, {key}, {data}||undef
 !$_[0]->{-table}->{$_[1]}->{-ixcnd}
 ? &{$_[0]->{-die}}('recIndex(' .$_[1] .') -> not described index')
 : $_[3]
 ? $_[0]->dbiUpd({-table=>$_[1], -key=>$_[2], -save=>1}, $_[$#_])
 : $_[0]->dbiDel({-table=>$_[1], -key=>$_[2]});
}


sub recReindex{	# Reindex database
		# self, clear, indexes
 my ($s, $c, @i) =@_;
 $s->varLock();
 my @t =grep {!$s->{-table}->{$_}->{-ixcnd}} $s->mdlTable();
    @i =grep { $s->{-table}->{$_}->{-ixcnd}} keys %{$s->{-table}} if !@i;
 if ($c) {
	foreach my $i (@i) {
		$s->dbiTrunc($i);
	}
 }
 foreach my $t (@t) {
	$s->logRec('recReindex', $t);
	my $a ={-table=>$t,-version=>1};
	my $c =$s->recSel(%$a);
	my $r;
	while ($r =$c->fetchrow_hashref()) {
		$s->logRec('recReindex',$r);
		$s->rmiIndex($a, $r)
	}
 }
 $s
}


sub rfdName {	# Record's files directory name
		# self, command |table name, record data, subdirectory,...
 my $t =ref($_[1]) ? $_[1]->{-table} : $_[1];
 my $m =$_[0]->{-table}->{$t};
 join('/'
	, $_[0]->{-cgibus}
	? ($t
	  ,$_[2]->{$m->{-rvcActPtr} ||$_[0]->{-rvcActPtr} ||'-none'} ? 'ver' : 'act')
	: ($_[2]->{$m->{-rvcActPtr} ||$_[0]->{-rvcActPtr} ||'-none'} ? 'v'   : 'a'
	  ,$t)
	, &{$m->{-rfdName} 
	||$_[0]->{-rfdName} 
	||sub{		my $r ='';
			foreach my $e (@_[1..$#_]) {
				for (my $i =0; $i <=length($e); $i +=3) {
					my $v =substr($e, $i, 3);
					# $v =~s/([,;+:'"?*%\/\\])/uc sprintf("%%%02x",ord($1))/eg;
					$v =~s/([^a-z0-9_-])/uc sprintf("%%%02x",ord($1))/eg;
					$r .=$v .'/'
				}
			}
			chop($r);
			$r
		}}(
		$_[0]
		, map {	defined($_[2]->{$_}) ? $_[2]->{$_} : $_[1]->{-key}->{$_}
			} @{$m->{-key}})
	. $RISM2
	, map {	my $v =$_; 
		$v =~s/([,;+:'"?*%])/uc sprintf("%%%02x",ord($1))/eg;
		$v} @_[3..$#_]	# encoding as 'rfaUpload'
	)
}


sub rfdPath {	# Record's files directory path
		# self, -path|-url|-urf, rfdName |{data} |({command}|table, {data}), ?subdirectory...
 return(undef)	if !$_[0]->{$_[1]};
 join('/'
	, $_[0]->{-cgibus}
	? ($_[1] eq '-path' 
		? $_[0]->{-cgibus} 
		: $_[1] ne '-urf'
		? $_[0]->{$_[1]}
		: !$_[0]->{$_[1]}	# !!! lost code, for example
		? (($ENV{REMOTE_ADDR}||'') ne '127.0.0.1' ? $_[0]->{-url} : $_[0]->{-path})
		: $_[0]->{$_[1]})
	: $_[1] ne '-urf'
	? $_[0]->{$_[1]} .'/rfa' # -url, -path
	: !$_[0]->{$_[1]}		# !!! lost code, for example
	? (($ENV{REMOTE_ADDR}||'') ne '127.0.0.1' ? $_[0]->{-url} : $_[0]->{-path}) .'/rfa'
	: ($_[0]->{-urf} eq $_[0]->{-url}) 
		|| (substr($_[0]->{-urf},7) eq $_[0]->{-path})
	? $_[0]->{-urf} .'/rfa'
	: $_[0]->{-urf}
	, !ref($_[3]) # rfdName, !ref($_[2]) && !ref($_[3])
	? ((ref($_[2]) 
		? $_[2]->{-file} 
		|| return(&{$_[0]->{-die}}('rfdPath(' .$_[0]->strdata(@_) .') -> no file attachments')||'')
		: $_[2])
	  ,map {my $v =$_;
		$v =~s/([,;+:'"?*%])/uc sprintf("%%%02x",ord($1))/eg;
		$v} @_[3..$#_])	# encoding as 'rfdName' and 'rfaUpload'
	: rfdName($_[0],@_[2..$#_]))
}


sub rfdEdmd {	# Record's files directory editing allowed?
		# self, command |table name, record data
 my $m =$_[0]->{-table}->{
		ref($_[1]) 
		? ($_[1]->{-table} || $_[1]->{-form} && $_[0]->{-form}->{$_[1]->{-form}}->{-table})
		: ($_[0]->{-table}->{$_[1]} && $_[1] ||$_[0]->{-form}->{$_[1]}->{-table})
		};
 my $u =$m->{-rvcChgState}	||$_[0]->{-rvcChgState};
 my $v =$m->{-rvcActPtr}	||$_[0]->{-rvcActPtr};
 my $r =$_[2];
 !$v || ($u && ($r->{$u->[0]} && grep {$r->{$u->[0]} eq $_} @{$u}[1..$#{@$u}]))
}


sub rfdStamp {	# Stamp record with files directory name, create if needed
		# self, command |table name, record data, acl set
 my $d =rfdName(@_[0..2]);
 my $p =rfdPath($_[0],-path=>$d);
 my $e =rfdEdmd(@_[0..2]);
 my $r =$_[2];
 my $w =$_[3];

 $_[0]->pthMk($p) if $e;

 if (-d $p)	{ $r->{-file} =$d; $r->{-fupd} =$d if $e}
 else		{ delete $r->{-file}; delete $r->{-fupd}}

 if ($r->{-file} && $w) {	# set ACL
	my $s =$_[0];
	my $m =$s->{-table}->{ref($_[1]) ? $_[1]->{-table} : $_[1]};
	my $wr=$m->{-racReader} ||$s->{-racReader};
	   $wr=[map {defined($r->{$_}) ? (split /\s*[,;]\s*/i, $r->{$_}) : ()} @$wr] if $wr;
	my $ww=$m->{-racWriter} ||$s->{-racWriter};
	   $ww=[map {defined($r->{$_}) ? (split /\s*[,;]\s*/i, $r->{$_}) : ()} @$ww] if $ww;
	if ($wr ||$ww) {
		my $ld=$^O eq 'MSWin32' && $s->w32domain() || '';
		my @wa=	map {$_ =~s/ /_/g; $_}
			map {$_ =~/^([^\\@]+)([\\@])([^\\@]+)$/ 
				? ($_, $3 .($2 eq '@' ? '\\' : '@') .$1) 
				: $ld
				? ($_, $ld .'\\' .$_, $_ .'@' .$ld)
				: $_}
			(map {ref($_) ? @$_ : ()} $s->{-fswtr}, $s->{-fsrdr}, $ww, $wr);
		my $wf=$s->hfNew('+>',"$p/.htaccess");
		$wf->store('<Files "*">', "\n"
			,"require user\t"	.join(' ',@wa), "\n"
			,"require group\t"	.join(' ',@wa), "\n"
			,'</Files>',"\n");
		$wf->close();
	}
	if (($wr ||$ww) && $^O eq 'MSWin32' && Win32::IsWinNT()) { # $ENV{OS} && $ENV{OS}=~/Windows_NT/i
		$p =~s/\//\\/g;
		$s->osCmd('cacls', "\"$p\"", '/T','/C','/G'
		,(map { $_ =~/\s/ ? "\"$_\"" : $_
			} map{(m/([^@]+)\@([^@]+)/ ? "$2\\$1" : $_) .':F'
				} ref($s->{-fswtr}) ? (@{$s->{-fswtr}}) : ($s->{-fswtr}))
		,$s->{-fsrdr}
		?(map { $_ =~/\s/ ? "\"$_\"" : $_
			} map{(m/([^@]+)\@([^@]+)/ ? "$2\\$1" : $_) .':R'
				} ref($s->{-fsrdr}) ? (@{$s->{-fsrdr}}) : ($s->{-fsrdr}))
		:()
		,sub{CORE::print "Y\n"});
		if ($e && $ww) {
			foreach my $u (map {m/([^@]+)\@([^@]+)/ ? "$2\\$1" : $_} @$ww) {
				$s->osCmd('-i','cacls', "\"$p\""
				, '/E','/T','/C','/G'
				, ($u =~/\s/ ? "\"$u\"" : $u) .':F')
			}
			foreach my $u (map {m/([^@]+)\@([^@]+)/ ? "$2\\$1" : $_} $wr ? @$wr : ()) {
				$s->osCmd('-i','cacls', "\"$p\""
				, '/E','/T','/C','/G'
				, ($u =~/\s/ ? "\"$u\"" : $u) .':R')
			}
		}
		else {
			foreach my $u (map {m/([^@]+)\@([^@]+)/ ? "$2\\$1" : $_
					} map {$_ ? @$_ : ()} $ww, $wr) {
				$s->osCmd('-i','cacls', "\"$p\""
				, '/E','/T','/C','/G'
				, ($u =~/\s/ ? "\"$u\"" : $u) .':R')
			}
		}
	}
 }

 $r->{-file}
}


sub rfdCp {	# Copy record's files directory to another record
		# self, source {record} |rfdName, dest {command} |table, {record}
 my $fd =ref($_[1]) ? $_[1]->{-file} : $_[1];
    return(0) if !$fd;
 my $fp =rfdPath($_[0],-path=>$fd);
    return(0) if ! -d $fp;
 my $td =rfdName($_[0], @_[2..$#_]);
 my $tp =rfdPath($_[0],-path=>$td);
 $_[0]->pthMk($tp) && $_[0]->pthCp('-r',$fp,$tp)
 && ($_[3]->{-file} =$td);
}


sub rfdRm {	# Remove record's files directory
		# self, rfdName |{record} |({command} |table, {record})
 my $p =rfdPath($_[0], -path=>ref($_[1]) && $_[1]->{-file} ? $_[1]->{-file} : @_[1..max($_[0], 2, $#_)]);
    $p =-d $p ? $_[0]->pthRm('-r', $p) && $_[0]->pthCln($p) : $p;
 delete $_[1]->{-file} if $p && ref($_[1]);
 $p
}


sub rfdCln {	# Clean record's files directory, delete if empty
		# self, rfdName |{record} |({command} |table, {record})
 my $p =rfdPath($_[0], -path=>ref($_[1]) && $_[1]->{-file} ? $_[1]->{-file} : @_[1..max($_[0], 2, $#_)]);
    $p =$_[0]->pthCln($p);
 delete $_[1]->{-file} if $p && ref($_[1]) && !-d $p;
 $p
}


sub rfdGlobn {	# Glob record's files directory, return attachments names
		# self, rfdName |{record} |({command} |table, {record}), subdirectory...
 $_[0]->pthGlobn($_[0]->rfdPath(-path=>@_[1..$#_]) .'/*')
}


sub rfaRm {	# Delete named attachment(s) in record's files directory
		# self, rfdName |{record} |({command} |table, {record}), attachment|[attachments]
 grep {$_[0]->pthRm('-r',$_[0]->rfdPath(-path=>@_[1..$#_-1], $_))
	} ref($_[$#_]) ? @{$_[$#_]} : $_[$#_]
}


sub rfaUpload {	# Upload named attachment into record's files directory
		# self, rfdName |{record} |({command} |table, {record}), cgi file
 my $fn =$_[0]->cgi->param($_[$#_]);
    $fn =$fn =~/[\\\/]([^\\\/]+)$/ ? $1 : $fn;
    $fn =~s/([,;+:'"?*%])/uc sprintf("%%%02x",ord($1))/eg;
 my $fh =$_[0]->cgi->upload($_[$#_])
        ||return(&{$_[0]->{-die}}($_[0]->lng(0,'rfaUpload') ."('" .$_[$#_] ."') CGI::upload -> " .$_[0]->lng(1,'rfaUplEmpty') ."\n"));
 binmode($fh);
 eval('use File::Copy');
 File::Copy::copy($fh, $_[0]->rfdPath(-path=>@_[1..$#_-1], $fn))
 || &{$_[0]->{-die}}($_[0]->lng(0,'rfaUpload') ."('" .$_[$#_] ."'): File::Copy::copy -> $!\n");
 eval{close($fh)};
}


sub recNew {    # Create new record to be inserted into database
		# -table=>name, field=>value || -data=>{values}
		# -key=>sample
 my	$s =$_[0];
	$s->logRec('recNew', @_[1..$#_]);
 my	$a =(@_< 3 && ref($_[1]) ? $_[1] : {@_[1..$#_]});
 my	$d =$a->{-data} ? {%{$a->{-data}}} : exists($a->{-data}) ? {} : $a;
 local	$a->{-table} =recType ($s, $a, $d);
 local	$a->{-key}   =rmlKey($s, $a, $d);
 my	$m =mdeTable($s,$a->{-table});
 my	$r ={%$d};
 my	$p =(grep {$_} values %{$a->{-key}}) ? $s->recRead(%$a, -data=>undef, -test=>1) : {};
 #	map {$r->{$_} =$p->{$_}} keys %$p;
 foreach my $w (qw(-rvcInsBy -rvcUpdBy)) {foreach my $c ($m, $s) {
	next if !$c->{$w}; $r->{$c->{$w}} =$s->user; last
 }}
 foreach my $w (qw(-rvcInsWhen -rvcUpdWhen)) {foreach my $c ($m, $s) {
	next if !$c->{$w}; delete $r->{$c->{$w}}; last
 }}
 foreach my $w (qw(id -file -fupd)) {
	 delete $r->{$w};
 }
 $r->{-new} =$s->strtime();
 $r->{-editable} =$s->user() if $s->{-rac} && ($m->{-racWriter}||$s->{-racWriter});
 rmiTrigger($s, $a, $r, $p, qw(-recNew0C));
 rmiTrigger($s, $a, $r, undef, qw(-recForm0C));
 rmiTrigger($s, $a, $d, $r, qw(-recNew1R -recNew1C -recForm1C));
 $r
}


sub recForm {   # Recalculate record - new or existing
		# -table=>name, field=>value || -data=>{values}
		# -key=>original
 my	$s =$_[0];
	# $s->logRec('recForm', @_[1..$#_]);
 my	$a =(@_< 3 && ref($_[1]) ? $_[1] : {@_[1..$#_]});
 my	$d =$a->{-data} ? $a->{-data} : exists($a->{-data}) ? {} : $a;
 local	$a->{-table} =recType ($s, $a, $d);
 local	$a->{-key}   =rmlKey($s, $a, $d);
 my	$m =mdeTable($s,$a->{-table});
 my	$r =(!$d->{-new} && (grep {$_} values %{$a->{-key}}) && $s->recRead(%$a,-data=>undef,-test=>1)) ||{};
	map {$r->{$_} =$d->{$_}} keys %$d;
 foreach my $w (qw(-rvcInsBy -rvcUpdBy)) {foreach my $c ($m, $s) {
	next if !$c->{$w}; $r->{$c->{$w}} =$s->user if !$r->{$c->{$w}}; last
 }}
 rmiTrigger($s, $a, $r, undef, qw(-recForm0C));
 rmiTrigger($s, $a, $d, $r, qw(-recForm1C));
 $r
}


sub recIns {    # Insert record into database
		# -table=>table, field=>value || -data=>{values}
		# -key=>{sample}, -from=>cursor
 my	$s =$_[0];
	$s->varLock if $s->{-serial} && $s->{-serial} ==1;
	$s->logRec('recIns', @_[1..$#_]);
 my	$a =(@_< 3 && ref($_[1]) ? {%{$_[1]}} : {@_[1..$#_]});
 my	$d =$a->{-data} ? {%{$a->{-data}}} : exists($a->{-data}) ? {} : $a;
 local  $a->{-table}=recType ($s, $a, $d);
 local	$a->{-key}  =rmlKey($s, $a, $d);
 my	$m =mdeTable($s,$a->{-table});
 my	$r =undef;
 my	$v =$m->{-rvcActPtr}	||$s->{-rvcActPtr};
 my	$b =$m->{-rfa}	||$s->{-rfa};
 my	$p =(grep {$_} values %{$a->{-key}}) && $s->recRead(%$a, -data=>undef, -test=>1);
 if ($p) {		# form record with prototype
    my $t =recData($s, $p);
    delete $t->{$v};
    @{$t}{keys %$d} =values %$d;
    if ($a eq $d)	{$a =$d =$t}
    else		{$d =$t}
 }
 foreach my $w (qw(-rvcInsBy -rvcUpdBy)) {foreach my $c ($m, $s) {
	next if !$c->{$w}; $d->{$c->{$w}} =$s->user; last
 }}
 foreach my $w (qw(-rvcInsWhen -rvcUpdWhen)) {foreach my $c ($m, $s) {
	next if !$c->{$w}; $d->{$c->{$w}} =$s->strtime; last
 }}
 if ($a->{-from}) {	# insert from cursor
	while (my $t =$a->{-from}->fetchrow_hashref()) {
		$t ={%$t};	# readonly hash
		rfdStamp($s, $a, $t) if $b;
		@{$t}{recFields($s, $d)} =recValues($s, $d);
		rmiTrigger($s, $a, $t, undef, qw(-recIns0C -recForm0C -recIns0R -recInsID));
		rfdCp	  ($s, $t->{-file}, $a, $t) if $t && $t->{-file};
		rfdCp	  ($s, $p->{-file}, $a, $t) if $p && $p->{-file};
		rmiIndex  ($s, $a, $t) if $m->{-index} ||$s->{-index};
		$r =$s->dbiIns($a, $t);
		rfdStamp($s, $a, $r, '+') if $t && $t->{-file} || $p && $p->{-file};
		rmiTrigger($s, $a, $t, $r, qw(-recIns1R -recIns1C)) if $r;
	}
	$r =$a;
 }
 else {			# insert single record
	rmiTrigger($s, $a, $d, undef, qw(-recIns0C -recForm0C -recIns0R -recInsID));
	rfdCp	  ($s, $p, $a, $d)	if $p && $p->{-file};
	rmiIndex  ($s, $a, $d, undef)	if $m->{-index} ||$s->{-index};
	$r =$s->dbiIns($a, $d);
	rfdStamp  ($s, $a, $r, '+');
	$r->{-editable} =$s->user if $r && $s->{-rac} && ($m->{-racWriter}||$s->{-racWriter});
	rmiTrigger($s, $a, $d, $r, qw(-recIns1R -recIns1C -recForm1C)) if $r;
 }
 return($r)
}


sub dbiTblExpr {# DBI / SQL table name expression
  !$_[0]->{-table}->{$_[1]} || !$_[0]->{-table}->{$_[1]}->{-expr} 
 ? $_[1]
 : $_[0]->{-table}->{$_[1]}->{-expr} =~/\s/ 
 ? $_[0]->{-table}->{$_[1]}->{-expr}
 : $_[0]->{-table}->{$_[1]}->{-expr} .' AS ' .$_[1]
}


sub dbiTblExp1 {# DBI / SQL first table expression for insert/update/delete
  !$_[0]->{-table}->{$_[1]} || !$_[0]->{-table}->{$_[1]}->{-expr} 
 ? $_[1]
 : $_[0]->{-table}->{$_[1]}->{-expr} =~/^([^\s]+\s+AS\s+[^\s]+)/i
 ? $1
 : $_[0]->{-table}->{$_[1]}->{-expr} =~/\s/ 
 ? $_[0]->{-table}->{$_[1]}->{-expr}
 : $_[0]->{-table}->{$_[1]}->{-expr} # .' AS ' .$_[1] # sql syntax
}


sub dbiIns {    # Insert record into database
		# -table=>table, field=>value
		# -save=>boolean
 my ($s, $a, $d) =@_;
 my  $f =$a->{-table};
 my  @c;
 my  $r =$a;
     $s->{-affected} =0;
 if (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-tn}->{-dbd}) eq 'dbi') {
	my $db=$s->dbi();
	my @a =recFields($s,$d);
	my @v;
	@c=( 'INSERT INTO ' 
		.dbiTblExp1($s, $f)
		.' (' .join(',', @a) 
		.') VALUES ('
		.join(','
			, $s->{-dbiph}
			? map {'?'} @a
		 	: map {mdeQuote($s, $s->{-table}->{$f}, $_, $d->{$_})
						} @a)
		.')'
		, $s->{-dbiph} ? ({}, map {$d->{$_}} @a) : ()
	);
	$s->logRec('dbiIns', @c);
	$db->do(@c)|| return(&{$s->{-die}}($s->lng(0,'dbiIns') .": do() -> " .($DBI::errstr ||'Unknown')) && undef);
	$s->{-affected} =$DBI::rows;
	$s->{-affected} =-$s->{-affected} if $s->{-affected} <0;
	return($a) if $s->{-affected} >1 ||$a->{-save};
	if ($s->{-dbiph}) {
		@a =grep {defined($d->{$_})} @a;
		@v =map  {$d->{$_}} @a;
	}
	@c =('SELECT * FROM ' .dbiTblExp1($s, $f) .' WHERE '
		.join(' AND '
			, $s->{-dbiph}
			? map {"$_=?"} @a
			: map {defined($d->{$_})
				? ($_ .'=' .mdeQuote($s, $s->{-table}->{$f}, $_, $d->{$_}))
				: ()
				} @a));
	$s->logRec('dbiIns', @c, @v ? {} : (), @v);
	$f =$db->prepare(@c);
	$r =$f && $f->execute(@v) && $f->fetchrow_hashref() || return(&{$s->{-die}}($s->lng(0,'dbiIns') .": selectrow_hashref() -> " .($DBI::errstr||'Empty result set')) && undef);
 }
 elsif (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-tn}->{-dbd}) eq 'dbm') {
	@c =	([map {$d->{$_}} 
			@{$s->{-table}->{$f}->{-key}}]
		,($r =recData($s, $d)));
	$s->logRec('dbiIns/kePut', $f, @c);
	$s->dbmTable($f)->kePut(@c) || return(&{$s->{-die}}($s->lng(0,'dbiIns') .": kePut() -> $@") && undef);
	$s->{-affected} =1;
 }
 elsif (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-tn}->{-dbd}) eq 'xmr') {
 }
 $r
}


sub dbiExplain {# Explain DML plan
 my $s =shift;
 return() if !$s->{-debug};
 my $i =ref($_[0]) ? shift : $s->dbi;
 my $q =shift;
 eval {
   my $c =$i->prepare("explain $q");
       $c->execute;
    my $r;
    while ($r =$c->fetchrow_hashref()) {
      $s->logRec('dbiExplain', join(', ', map {"$_=> " .$s->strquot($r->{$_})} @{$c->{NAME}}));
    }
 }
}


sub recUpd {    # Update record(s) in database
		# -table=>table, field=>value || -data=>{values}
		# -key=>{field=>value}, -where=>'condition', -version=>'+'|'-'
		# -optrec=>boolean
 my	$s =$_[0];
	$s->varLock if $s->{-serial} && $s->{-serial} ==1;
	$s->logRec('recUpd', @_[1..$#_]);
 my	$a =(@_< 3 && ref($_[1]) ? {%{$_[1]}} : {@_[1..$#_]});
 my	$d =$a->{-data} ? {%{$a->{-data}}} : exists($a->{-data}) ? {} : $a;
 local  $a->{-table}=recType ($s, $a, $d);
 local	$a->{-key}  =rmlKey  ($s, $a, $d);
 my	$m =mdeTable($s,$a->{-table});
 my	$r =undef;
 my	$w =mdeWriters($s, $m);
 my	$u =$m->{-rvcChgState}	||$s->{-rvcChgState};
 my	$o =$m->{-rvcCkoState}	||$s->{-rvcCkoState};
 my	$x =$m->{-rvcDelState}	||$s->{-rvcDelState};
 my	$v =$m->{-rvcActPtr}	||$s->{-rvcActPtr};
 my	$i =$m->{-index}	||$s->{-index};
 my	$b =$m->{-rfa}		||$s->{-rfa};
 my	$e;
 local  $a->{-version}= ref($a->{-version})
			? $a->{-version}
			: $v && (!$a->{-version} ||$a->{-version} eq '-')
			? [$v, @{$x||[]}]
			: ($a->{-version} ||'+');
 foreach my $w (qw(-rvcInsBy -rvcInsWhen)) {foreach my $c ($m, $s) {
	next if !$c->{$w}; delete $d->{$c->{$w}}; last
 }}
 foreach my $c ($m, $s) {
	next if !$c->{-rvcUpdBy}; $d->{$c->{-rvcUpdBy}} =$s->user; last
 }
 foreach my $c ($m, $s) {
	next if !$c->{-rvcUpdWhen}; $d->{$c->{-rvcUpdWhen}} =$s->strtime; last
 }
 rmiTrigger($s, $a, $d, undef, qw(-recUpd0C -recForm0C));
 if ($w ||$o ||$v ||$i ||grep {$s->{$_} || $m->{$_}} qw(-recUpd0R -recUpd -recUpd1R)) {
	my $c =$s->recSel(rmlClause($s, $a), -data=>undef);
	my $j =0;
	while ($r =$c->fetchrow_hashref()) {
		$j++; return(&{$s->{-die}}($s->lng(0,'recUpd') .": $j ". $s->lng(1,'-affected')) && undef)
			if $s->{-affect} && $j >$s->{-affect};
		# $r ={%$r};	# readonly hash, should be considered below
		return(&{$s->{-die}}($s->lng(0,'recUpd') .': ' .$s->lng(1,'recUpdAclStp')) && undef)
			if $w && !$s->ugmember(map {$r->{$_}} @$w);
		rfdStamp($s, $a, $r) if $b;
		if ($v	&& $r->{$v}			# prohibit version
			&& (!$o || (defined($r->{$o->[0]})
					&& ($r->{$o->[0]} ne $o->[1])))
					) {
			return(&{$s->{-die}}($s->lng(0,'recUpd') .': ' .$s->lng(1,'recUpdVerStp')) && undef)
		}
		elsif ($o  				# check-in
			&& (($r->{$o->[0]}||'') eq $o->[1])
			&& defined($d->{$o->[0]})
			&& ($d->{$o->[0]} ne $o->[1])
			&& (!$x || (defined($d->{$x->[0]}) 
					&& ($d->{$x->[0]} ne $x->[1])))
			&& $r->{$v}) {
			my $t =$r->{'id'};
			$e =$s->recUpd(%$r, %{recData($s,$d)}
					, 'id'=>$r->{$v}, $v=>undef
					, -table=>$a->{-table}, -key=>{'id'=>$r->{$v}});
			rfdRm	($s, $a->{-table}, $r)	if $r->{-file};
			rmiIndex($s, $a, undef, $r)	if $i;
			$s->dbiDel({-table=>$a->{-table}, -key=>{'id'=>$t}});
		}
		elsif ($o				# check-out
			&& (($r->{$o->[0]}||'') ne $o->[1])
			&& (($d->{$o->[0]}||'') eq $o->[1])) {
			my $n ={%$r}; @{$n}{recFields($s, $d)} =recValues($s, $d);
			$n->{$v} =$r->{'id'};
			rmiTrigger($s, $a, $n, undef, qw(-recForm0C -recUpd0R -recInsID));
			rfdCp	  ($s, $r->{-file}, $a, $n)	if $r->{-file};
			rfdStamp  ($s, $a, $n, '+')		if $r->{-file};
			rmiIndex  ($s, $a, $n, undef)		if $m->{-index} ||$s->{-index};
			$e =$s->dbiIns($a, $n);
			$e->{-file} =$n->{-file}		if $n->{-file};
		}
		elsif ($v && (!$u			# version
				|| (defined($r->{$u->[0]})
				   && !grep {$r->{$u->[0]} eq $_
					} @{$u}[1..$#{@$u}]))) {
			my $n ={%$r}; @{$n}{recFields($s, $d)} =recValues($s, $d);
			my $p ={%$r, $v=>$r->{'id'}, -table=>$a->{-table}};
			rmiTrigger($s, $a, $n, $r, qw(-recUpd0R));
					# !!! lost computed values
			rmiTrigger($s, $a, $p, undef, qw(-recInsID));
			rfdCp	  ($s, $r->{-file}, $a, $p)
					if $r 
					&& $r->{-file}
					&& (!$u 
					   || $a->{-file}
					   || ($d->{$u->[0]}
						&& grep {$d->{$u->[0]} eq $_
							} @{$u}[1..$#{@$u}]));
			do {	rfdRm  ($s, $a->{-table}, $n);
				rfdCp  ($s, $a->{-file},  $a->{-table}, $n);
				rfdCln ($s, $a->{-table}, $n)
				}
					if $a->{-file}
					&& (!$r->{-file} || $r->{-file} ne $a->{-file});
			rfdStamp  ($s, $a, $n, '+');
			rmiIndex  ($s, $a, $n, $r) if $i;
			rmiIndex  ($s, $a, $p)	   if $i;
			$p =$s->dbiIns({-table=>$a->{-table}, -save=>1}, $p);
		}
		else {					# update only
			my $n ={%$r}; @{$n}{recFields($s, $d)} =recValues($s, $d);
			rmiTrigger($s, $a, $n, $r, qw(-recUpd0R));
					# !!! lost computed values
			do {	rfdRm  ($s, $a->{-table}, $n);
				rfdCp  ($s, $a->{-file},  $a->{-table}, $n);
				}
					if $a->{-file}
					&& (!$r->{-file} || $r->{-file} ne $a->{-file});
			rfdStamp  ($s, $a, $n, '+') if $r && $r->{-file};
			rfdCln	  ($s, $a, $n)      if $r && $r->{-file} 
							  && $u 
							  && $n->{$u->[0]} 
							  && !grep {$n->{$u->[0]} eq $_
								} @{$u}[1..$#{@$u}];
			rmiIndex  ($s, $a, $n, $r)  if $i;
		}
	} 
	$r =$e || $s->dbiUpd($a, $d);
 }
 else {
	$r =$s->dbiUpd($a, $d);
 }
 return(&{$s->{-die}}($s->lng(0,'recUpd') .': ' .($s->{-affected}||0) .' ' .$s->lng(1,'-affected')) && undef)
	if $s->{-affect} && (($s->{-affected}||0) != $s->{-affect});
 if ($r && ($s->{-affected}||0) ==1) {
	rfdStamp($s, $a, $r) 
			if $b;
	$r->{-editable} =$w ? $s->ugmember(map {$r->{$_}} @$w) : $s->user
			if $s->{-rac};
	rmiTrigger($s, $a, $d, $r, qw(-recUpd1C -recForm1C));
 }
 elsif ($r) {
	rmiTrigger($s, $a, $d, $r, qw(-recUpd1C))
 }
 $r
}


sub dbiUpd {    # Update record(s) in database
		# -table=>table, field=>value || -data=>{values}
		# -key=>{field=>value}, -where=>'condition'
		# -save=>boolean, -optrec=>boolean
 my ($s, $a, $d) =@_;
 my  $f =$a->{-table};
 my  @c;
 my  $r =undef;
     $s->{-affected} =0;
 if (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-tn}->{-dbd}) eq 'dbi') {
	my $db =$s->dbi();
	my @cn =!$a->{-key} ? () : $s->{-dbiph} ? sort keys %{$a->{-key}} : keys %{$a->{-key}};
	my(@a, @v); @a =recFields($s,$d) if $s->{-dbiph};
	@c=('UPDATE '
		.dbiTblExp1($s, $f)
		.' SET '
		.join(','
		, $s->{-dbiph}
		? (map {"$_=?"} @a)
		: (map {$_ .'=' .mdeQuote($s, $s->{-table}->{$f}, $_, $d->{$_})
			} recFields($s,$d)))
		." WHERE "
		.join(' AND '	
			, dbiKeyWhr($s, $a, @cn)	# Key condition
			, $a->{-where} 
			? '(' .$a->{-where} .')' 	# Where condition 
			: ()
			, ref($a->{-version})		# Version control $f.
			? ("(( " .$a->{-version}->[0] .' IS NULL'
			." OR  " .$a->{-version}->[0] ."='')"
			.($a->{-version}->[1] 
				? ' AND ' .$a->{-version}->[1] ." <> '" .$a->{-version}->[2] ."')"
				: ')'))
			: ()
			, dbiACLike($s, $f, undef	# Access control
				,mdeWriters($s, $f), $s->ugnames())
			)
		,$s->{-dbiph} ? ({}, (map {$d->{$_}} @a), (map {ref($a->{-key}->{$_}) ? @{$a->{-key}->{$_}} : $a->{-key}->{$_}} @cn)) : ()
	);
	$s->logRec('dbiUpd',@c);
	$db->do(@c) || return(&{$s->{-die}}($s->lng(0,'dbiUpd') .": do() -> " .($DBI::errstr||'Unknown')) && undef);
	$s->{-affected} =$DBI::rows;
	$s->{-affected} =-$s->{-affected} if $s->{-affected} <0;
	$s->logRec('dbiUpd','affected',$s->{-affected});
	return($s->dbiIns($a, $d)) 
		if !$s->{-affected} 
		&& ($a->{-save}
		||  $s->{-table}->{$f}->{-ixcnd});
	return($s->recIns($a, $d))
		if !$s->{-affected}
		&& ($a->{-optrec}
		||  $s->{-table}->{$f}->{-optrec});
	return($a) if $s->{-affected} >1 ||$a->{-save};
	if ($s->{-dbiph}) {
		@cn =grep {defined($d->{$_}) 
			|| !exists($d->{$_}) && defined($a->{-key}->{$_})
				} @cn;
		@v  =map  {defined($d->{$_}) ? $d->{$_} : $a->{-key}->{$_}
				} @cn;
	}
	@c =('SELECT * FROM ' .dbiTblExp1($s, $f) .' WHERE '
		.join(' AND '	
			, $s->{-dbiph}
			? (map {  "$_=?" } @cn)
			: (map {  defined($d->{$_})
				? ($_ .'=' .mdeQuote($s, $s->{-table}->{$f}, $_, $d->{$_}))
				: exists($d->{$_})
				? ()
				: defined($a->{-key}->{$_})
				? ($_ .'=' .mdeQuote($s, $s->{-table}->{$f}, $_, $a->{-key}->{$_}))
				: ()
				} @cn)
			, $a->{-where} ? '(' .$a->{-where} .')' : ())
	);
	$s->logRec('dbiUpd', @c, @v ? {} : (), @v);
	$f =$db->prepare(@c);
	$r =$f && $f->execute(@v) && $f->fetchrow_hashref() || return(&{$s->{-die}}($s->lng(0,'dbiUpd') .": selectrow_hashref() -> " .($DBI::errstr||'Empty result set')) && undef);
 }
 elsif (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-tn}->{-dbd}) eq 'dbm') {
	my $h =$s->dbmTable($f);
	my @f =recFields($s,$d);
	my @v =recValues($s,$d);
	my $j =0;
	$s->{-affected} =
	$s->dbmSeek($a, sub {
			$j++;
			return(&{$s->{-die}}($s->lng(0,'dbiUpd') .": $j ". $s->lng(1,'-affected')) && undef)
				if $s->{-affect} && $j >$s->{-affect};
			$r =$_[2];
			@{$r}{@f} =@v;
			my $k =[map {$r->{$_}} @{$s->{-table}->{$f}->{-key}}];
			$s->logRec('dbiUpd/kePut', $f, $k, $_[1], $r);
			$h->kePut($k, $_[1], $r);
	});
	if (!$s->{-affected}) {
		return($s->dbiIns($a, $d)) 
			if $a->{-save} || $s->{-table}->{$f}->{-ixcnd};
		return($s->recIns($a, $d))
			if $a->{-optrec} || $s->{-table}->{$f}->{-optrec};
		return(&{$s->{-die}}($s->lng(0,'dbiUpd') .": dbmSeek() -> " .($@ ||'not found')) && undef)
	}
	$r =$s->{-affected} >1 ? $a : $r;
 }
 $r
}


sub dbmSeek {	# Select records from dbm file using -key and -where
 my ($s, $a, $e) =@_;
 my $m =$s->{-table}->{$a->{-table}};			# metadata
 my $i =$m->{-key};					# index
 my $k =($a->{-key}					# key index part
	? [map {$a->{-key}->{$_}} grep {exists $a->{-key}->{$_}} @$i] 
	: []);
 my $ko=$s->{-keyqn};					# key compare opt	
 my $wk={ $a->{-key}					# key where part
	? (map {($_=>$a->{-key}->{$_})} (grep {my $v =$_; !grep {$v eq $_} @$i} keys %{$a->{-key}}))
	: ()
	};
    $wk=undef if !%$wk;
 my $o =($a->{-keyord} ||$a->{-orderby} ||$a->{-order})	# order request
	|| (!$e && (!@$k) ? $KSORD : '-aeq');
    $o ='-' .$o if substr($o,0,1) ne '-';
 my $ox=@$k						# order execute
	? $o 
	: $e 
	? $o 
	: $o =~/^-[af]/ 
	? '-aall' 
	: '-dall';
 my $ws;						# 'where' key cond
 if ($wk) {
	$ws =substr($o, 2);
	$ws =0 ? undef
	: $ws eq 'eq' || $ws eq 'all'
		      ? sub{my($k,$v,$d); foreach $k (keys %$wk) {
				$v =$wk->{$k};	$d =$_[2]->{$k}; 
				return(undef) if
				$ko && (!defined($v) || ($v eq ''))
				?  defined($d) && $d ne ''
				: !defined($d)	? defined($v)
				: !defined($v)	? defined($d)
				: ref($v)
				? !grep {$d eq $_} @$v
				: $d =~/^[\d\.]+\$/ && $v =~/^[\d\.]+\$/
				? $d != $v	: $d ne $v;
			}; 1}
	: $ws eq 'ge' ? sub{my($k,$v,$d); foreach $k (keys %$wk) {
				$v =$wk->{$k};	$d =$_[2]->{$k}; 
				return(undef) if
				$ko && (!defined($v) || ($v eq ''))
				?  defined($d) && ($d lt '')
				: !defined($d)	? defined($v)
				: !defined($v)	? 0
				: ref($v)
				? !grep {$d ge $_} @$v
				: $d =~/^[\d\.]+\$/ && $v =~/^[\d\.]+\$/
				? $d < $v	: $d lt $v;
			}; 1}
	: $ws eq 'gt' ? sub{my($k,$v,$d); foreach $k (keys %$wk) {
				$v =$wk->{$k};	$d =$_[2]->{$k}; 
				return(undef) if
				$ko && (!defined($v) || ($v eq ''))
				? !defined($d) || ($d le '')
				: !defined($d)	? 1
				: !defined($v)	? !defined($d)
				: ref($v)
				? !grep {$d gt $_} @$v
				: $d =~/^[\d\.]+\$/ && $v =~/^[\d\.]+\$/
				? $d <= $v	: $d le $v;
			}; 1}
	: $ws eq 'le' ? sub{my($k,$v,$d); foreach $k (keys %$wk) {
				$v =$wk->{$k};	$d =$_[2]->{$k}; 
				return(undef) if
				$ko && (!defined($v) || ($v eq ''))
				?  defined($d) && ($d gt '')
				: !defined($d)	? 0
				: !defined($v)	? defined($d)
				: ref($v)
				? !grep {$d le $_} @$v
				: $d =~/^[\d\.]+\$/ && $v =~/^[\d\.]+\$/
				? $d > $v	: $d gt $v;
			}; 1}
	: $ws eq 'lt' ? sub{my($k,$v,$d); foreach $k (keys %$wk) {
				$v =$wk->{$k};	$d =$_[2]->{$k}; 
				return(undef) if
				$ko && (!defined($v) || ($v eq ''))
				? !defined($d) || ($d ge '')
				: !defined($d)	? !defined($v)
				: !defined($v)	? 0
				: ref($v)
				? !grep {$d lt $_} @$v
				: $d =~/^[\d\.]+\$/ && $v =~/^[\d\.]+\$/
				? $d >= $v	: $d ge $v;
			}; 1}
	: undef
 }

 my $wr=$a->{-urole} 					# 'where' role cond
	&& mdeRole($s, $m, $a->{-urole});
 if ($wr) {
	my $wl	=$wr;
	my $wn	=$a->{-uname} ? $s->ugnames($a->{-uname}) : $s->ugnames();
	my $wx	=$a->{-urole} =~/^(?:principal|user)$/i
		? mdeRole($s, $m, 'actor') 
		: $a->{-urole} =~/^(?:principals|users)$/i
		? mdeRole($s, $m, 'actors') 
		: [];
	$wr	=sub {	foreach my $n (@$wn) {
				foreach my $v (@$wx) {
					return(undef) if $_[2]->{$v} =~/\b\Q$n\E\b/i
				}
				foreach my $v (@$wl) {
					return($n) if $_[2]->{$v} =~/\b\Q$n\E\b/i
				}
			}
			undef
	}
 }
 my $wa=$a->{-urole} && !$a->{-uname} 			# 'where' access cond
	? undef 
	: mdeReaders($s, $m);

 my $wv=$a->{-version};					# 'where' version cond
    $wv=undef if !ref($wv) || !@$wv;
 my $ft=$a->{-ftext};					# full-text find
 my $wf=$a->{-filter};					# 'where' filter expr
 my $wc=$a->{-where};					# 'where' condition
 my $we=$wc;						# 'where' cond source
 if (defined($wc) && !ref($wc) && $wc) {		# ... from string
	# !!! perl operations incompatible with SQL
	my $wm =$we; $we =''; 
	my ($wa, $wt, $wq);
	while (length($wm)) {
		$wa =!$wa;
		if ($wm =~/(?<!\\)((?:\\\\)*["'])/) {	# ... unescaped quote
			$wt =$`; $wm =$'; $wq =$1;
		}
		else {
			$wt =$wm; $wm =''; $wq ='';
		}
		if ($wa) {				# ... translate expr
			$wt =~s/((?<![><=])=)/'=' .$1/ge;
			$wt =~s/({\w+\})/'$_->' .$1/ge;
			$wt =~s/\b((?<!\{)\w{1,}(?!\s*\())\b/my $v =$1; $v !~\/^(?:and|or|eq|ge|gt|le|lt)$\/i ? '$_->{' .$v .'}' : $v/ge;
		}					# !!! good expr syntax?
		$we .=$wt .$wq;
	}
	$wc =$s->ccbNew($we);
 }
 my $w =sub{local $_ =$_[2];				# 'where' construct
	   (!$wv || (!$_[2]->{$wv->[0]} && (!$wv->[1] ||!$_[2]->{$wv->[1]} ||($_[2]->{$wv->[1]} ne $wv->[2]))))
	&& (!$ws || &$ws(@_))
	&& (!$wc || &$wc(@_))
	&& (!$wa || ugmember($s, map {$_[2]->{$_}} @$wa))
	&& (!$wr || &$wr(@_))
	&& (!$ft || grep {defined($_[2]->{$_}) && $_[2]->{$_} =~/\Q$ft\E/i} keys %{$_[2]})
	&& (!$wf || &$wf(@_))
	};
 $s->logRec('dbmSeek'
	, $a->{-table}, $ox, $k
	, $wv	? (-version=> $wv)	: ()
	, $wk	? ('-' .substr($o, 2)=>$wk)	 : ()
	, $we	? (-where=>$we)		: ()
	, $wa	? (-rac	=>$wa)		: ()
	, $wr	? (-urole=>$a->{-urole}, -uname=>$a->{-uname}||'') : ()
	, $ft	? (-ftext=>$ft)		: ()
	, $wf	? (-filter=>$wf)	: ()
	, $e	? (-subw=>$e)		: ()
	);
 $s->dbmTable($a->{-table})->keSeek($ox,$k,$w,$e);
}


sub dbiKeyWhr {	# SQL -key -order query condition
		# self, {command}, key field names
 my ($s, $a, @cn)=@_;
    @cn =!$a->{-key} ? () : $s->{-dbiph} ? sort keys %{$a->{-key}} : keys %{$a->{-key}}
	if !@cn;
   !@cn && return(@cn);
 my $kc =$a->{-keyord} ||$a->{-order};
    $kc =!$kc || ref($kc) || substr($kc,0,1) ne '-'
	? ''
	: {'eq'=>'=','ge'=>'>=','gt'=>'>','le'=>'<=','lt'=>'<'}->{substr($kc,2)}||'=';
    $kc	='' if $kc eq '=';
 my $db =$s->dbi();
 $s->{-dbiph}
 ?(map {  ref($a->{-key}->{$_})
	? do{	my $n =$_; my $m =$s->{-table}->{$a->{-table}};
		@{$a->{-key}->{$_}}
		? ('(' .join(' OR ', map {$n .($kc  ||'=') .'?'} @{$a->{-key}->{$_}}) .')')
		: ()
		}
	: $s->{-keyqn} && (!defined($a->{-key}->{$_}) || ($a->{-key}->{$_} eq ''))
	? (!$kc ? '(' .$_ .' IS NULL OR ' .$_ ."='' OR $_=?)" : $kc =~/=/ ? '(' .$_ .' IS NULL OR ' .$_ .$kc ."'' OR $_ $kc ?)" : ('(' .$_ .$kc ."'' OR $_ $kc ?)"))
	: !defined($a->{-key}->{$_})
	? (!$kc ? '(' .$_ .' IS ?)' : $kc =~/=/ ? '(' .$_ .' IS NULL OR ' .$_ .$kc .'?)' : ('(' .$_ .$kc .'?)'))
	: ($_ .($kc  ||'=') .'?')
	} @cn)
 :(map {  ref($a->{-key}->{$_})
	? do{	my $n =$_; my $m =$s->{-table}->{$a->{-table}};
		@{$a->{-key}->{$_}}
		? ('(' .join(' OR ', map {$n .($kc  ||'=') .mdeQuote($s, $m, $n, $_)} @{$a->{-key}->{$_}}) .')')
		: ()
		}
	: $s->{-keyqn} && (!defined($a->{-key}->{$_}) || ($a->{-key}->{$_} eq ''))
	? (!$kc ? '(' .$_ .' IS NULL OR ' .$_ ."='')" : $kc =~/=/ ? '(' .$_ .' IS NULL OR ' .$_ .$kc ."'')" : ('(' .$_ .$kc ."'')"))
	: !defined($a->{-key}->{$_})
	? (!$kc ? '(' .$_ .' IS NULL)' : $kc =~/=/ ? '(' .$_ .' IS NULL OR ' .$_ .$kc .'NULL)' : ('(' .$_ .$kc .'NULL)'))
	: ($_ .($kc  ||'=') .mdeQuote($s, $s->{-table}->{$a->{-table}}, $_, $a->{-key}->{$_}))
	} @cn);
}


sub dbiACLike {	# SQL Access Control LIKE / RLIKE
		# self, table, operation, [fields], [values], ?filter
 return(!$_[2] ? () : '') if !$_[3] ||!$_[4] || !@{$_[3]} ||!@{$_[4]};
				# RLIKE method detect / construct
 my $o	= $_[0]->{-dbiACLike} ||''; 
	# rlike regexp ~* similar regexp_like like eq|=; lc|lower; filter|sub
  # $o	= 'eq lc';
 my $e  = $_[0]->dbi->{Driver}->{Name};
    $e	= 0
	? ''
	: ($o =~/\b(?:rlike|regexp)\b/i)|| (!$o && ($e =~/^(?:mysql)/i))
	? 'RLIKE'	# MySQL, case insensitive for not binary strings
	: ($o =~/~\*/i)		|| (!$o && ($e =~/^(?:pg|postgresql)/i))
	? '~*'		# PostgreSQL, case insensitive
	: ($o =~/\b(?:similar)\b/i)
	? 'SIMILAR TO'	# SQL99, PostgreSQL: '%[[:<:]](|)[[:>:]]%'
	: ($o =~/\b(?:regexp_like)/i)
	? 'REGEXP_LIKE'	# Oracle 10: REGEXP_LIKE(zip, '[^[:digit:]]')
	: '';
 my $l	= !$e || ($o =~/\b(?:like|eq|=)\b/i)
	? $_[4]
	: ($e eq 'SIMILAR TO'
	  ? $_[0]->dbi->quote('%[[:<:]](' .join('|', @{$_[4]}) .')[[:>:]]%')
	  : $_[0]->dbi->quote( '[[:<:]](' .join('|', @{$_[4]}) .')[[:>:]]')
	  );
    $l	= ref($l)
	? (!$o || ($o =~/\b(?:lc|lower)\b/i) ? [map {lc($_)} @$l] : $l)
	: $e =~/\b(?:regexp_like)/i
	? (',' .($o =~/\b(?:lc|lower)\b/i ? lc($l) : $l) .')')
	: (' ' .$e .' ' .($o =~/\b(?:lc|lower)\b/i ? lc($l) : $l));

 if (ref($l) &&(@_ >4)		# LIKE method '-filter' constructor
 && (!$o || ($o =~/\b(?:filter|sub)\b/i))) {
	my $w =$_[0];
	my $e =$_[5];
	my $f =$_[3];
	$_[5] =$_[2] && $_[2] =~/not/i
		? sub {	foreach my $v (@$f) {
				next	if !exists($_[2]->{$v});
				foreach my $n (@$l) {
					return(undef) 
						if defined($_[2]->{$v})
						&& $_[2]->{$v} =~/\b\Q$n\E\b/i
				}
			} !$e || &$e(@_) }
		: sub {	foreach my $v (@$f) {
				if (!exists($_[2]->{$v})) {
					if ($w) {
					#	&{$w->{-warn}}("dbiACLike ACL filter ignoring due to ACL field(s) missing from SELECT list\n");
						CORE::warn("dbiACLike ACL filter ignoring due to ACL field(s) missing from SELECT list\n");
						$w =undef;
					}
					return(!$e || &$e(@_))
				}
				foreach my $n (@$l) {
					return(!$e || &$e(@_))
						if defined($_[2]->{$v})
						&& $_[2]->{$v} =~/\b\Q$n\E\b/i
				}
			} undef }
 }
 ' ' .($_[2] ? $_[2] .' ' : '')	# RLIKE / LIKE assembly
	.(!defined($l)
	? ''
	: !ref($l) && ($e =~/\b(?:regexp_like)\b/i)
	? '('	.( $o =~/\b(?:lc|lower)\b/i
		 ? join(' OR ', map {$e .'(LOWER(' .$_ .')' .$l} @{$_[3]})
		 : join(' OR ', map {$e .'(' .$_ .$l} @{$_[3]})
		) .')'
	: !ref($l)
	? '('	.( $o =~/\b(?:lc|lower)\b/i
		 ? join(' OR ', map {'LOWER(' .$_ .')' .$l} @{$_[3]})
		 : join(' OR ', map {$_ .$l} @{$_[3]})
		) .')'
	: $o =~/\b(?:eq|=)\b/i
	? '(' .join(' OR '			
		, map {	my $f =($o =~/\b(?:lc|lower)\b/i ? 'LOWER(' .$_ .')' : $_);
			map {$f .'=' .$_[0]->dbi->quote($_)
				} @$l
			} @{$_[3]}) .')'

	: '(' .join(' OR '			# !!! like precession
		, map {	my $f =(!$o || ($o =~/\b(?:lc|lower)\b/i) ? 'LOWER(' .$_ .')' : $_);
			map {$f .' LIKE ' .$_[0]->dbi->quote('%' .$_ .'%')
				} @$l
			} @{$_[3]}) .')'
	)
}


sub recDel {    # Delete record(s) in database
		# -table=>table
		# -key=>{field=>value}, -where=>'condition', -version=>'+'|'-'
 my	$s =$_[0];
	$s->varLock if $s->{-serial} && $s->{-serial} ==1;
	$s->logRec('recDel', @_[1..$#_]);
 my	$a =(@_< 3 && ref($_[1]) ? {%{$_[1]}} : {@_[1..$#_]});
 my	$d =$a->{-data} ? {%{$a->{-data}}} : exists($a->{-data}) ? {} : $a;
 local  $a->{-table}=recType($s, $a, $d);
 local	$a->{-key}  =rmlKey($s, $a, $d);
 my	$m =mdeTable($s,$a->{-table});
 my	$r =undef;
 my	$w =mdeWriters($s, $m);
 my	$x =$m->{-rvcDelState}	||$s->{-rvcDelState};
 my	$i =$m->{-index}	||$s->{-index};
 my	$b =$m->{-rfa}		||$s->{-rfa};
 rmiTrigger($s, $a, $d, undef, qw(-recDel0C -recForm0C));
 if ((($w||$i) && !$x) ||grep {$s->{$_} || $m->{$_}} qw(-recDel0R -recDel -recDel1R)) {
	my $c =$s->recSel(rmlClause($s, $a), -data=>undef);
	my $j =0;
	while ($r =$c->fetchrow_hashref()) {
		$j++; return(&{$s->{-die}}($s->lng(0,'recDel') .": $j ". $s->lng(1,'-affected')) && undef)
			if $s->{-affect} && $j >$s->{-affect};
		# $r ={%$r};	# readonly hash, should be considered below
		return(&{$s->{-die}}($s->lng(0,'recDel') .': ' .$s->lng(1,'recDelAclStp')) && undef)
			if $w && !$s->ugmember(map {$r->{$_}} @$w);
		return(&{$s->{-die}}($s->lng(0,'recDel') .': ' .$s->lng(1,'recUpdVerStp')) && undef)
			if $x && defined($r->{$x->[0]}) 
			&& ($r->{$x->[0]} eq $x->[1]);
		rfdStamp  ($s, $a, $r)		if $b;
		rmiTrigger($s, $a, $d, $r, qw(-recDel0R));
		rfdRm	  ($s, $r)		if !$x && $r->{-file};
		rmiIndex  ($s, $a, undef, $r)	if !$x && $i;
	}
	$r =($x ? $s->recUpd((map {$a->{$_} ? ($_=>$a->{$_}) : ()
				} qw(-table -key -where -version)), @$x)
		: $s->dbiDel($a, $d));
 }
 else {
	$r =($x	? $s->recUpd((map {$a->{$_} ? ($_=>$a->{$_}) : ()
				} qw(-table -key -where -version)), @$x)
		: $s->dbiDel($a, $d));
 }
 return(&{$s->{-die}}($s->lng(0,'recDel') .': ' .($s->{-affected}||0) .' ' .$s->lng(1,'-affected')) && undef)
	if $s->{-affect} && (($s->{-affected}||0) != $s->{-affect});
 rmiTrigger($s, $a, $d, $r, qw(-recDel1C)) if $r;
 $r
}


sub dbiDel {    # Delete record(s) in database
		# -table=>table
		# -key=>{field=>value}, -where=>'condition'
 my ($s, $a, $d) =@_;
 my $f =$a->{-table};
 my @c;
 my $r;
     $s->{-affected} =0;
 if (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-tn}->{-dbd}) eq 'dbi') {
	@c =('DELETE FROM ' 
		.dbiTblExp1($s, $f)
		.' WHERE '
		.join(' AND '
			, dbiKeyWhr($s, $a)		# Key condition
			, $a->{-where} 
			? '(' .$a->{-where} .')' 	# Where condition
			: ()
			, dbiACLike($s, $f, undef	# Access control
				, mdeWriters($s, $f), $s->ugnames())
			)
		, $s->{-dbiph} && $a->{-key} 
		? ({}, map {ref($a->{-key}->{$_}) ? @{$a->{-key}->{$_}} : $a->{-key}->{$_}} sort keys %{$a->{-key}}) 
		: ()
	);
	$s->logRec('dbiDel', @c);
	$s->dbi->do(@c) || return(&{$s->{-die}}($s->lng(0,'dbiDel') .": do() -> " .($DBI::errstr||'Unknown')) && undef);
	$s->{-affected} =$DBI::rows;
	$s->{-affected} =-$s->{-affected} if $s->{-affected} <0;
	$s->logRec('dbiDel','affected',$s->{-affected});
	return($s->{-affected} && $a);
 }
 elsif (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-tn}->{-dbd}) eq 'dbm') {
	my $h =$s->dbmTable($f);
	my $j =0;
	$s->{-affected} =
	$s->dbmSeek($a, sub {
		$j++; return(&{$s->{-die}}($s->lng(0,'dbiDel') .": $j " .$s->lng(1,'-affected')) && undef)
			if $s->{-affect} && $j >$s->{-affect};
                $s->logRec('dbiDel/keDel', $f, $_[1]);
		$h->keDel($_[1]);
	});
	return(&{$s->{-die}}($s->lng(0,'dbiDel') .": dbmSeek() -> $@") && undef) if !defined($s->{-affected});
 }
 $s->{-affected} && $a
}


sub dbiTrunc {	# Clear all records in the datafile
		# self, datafile name
 my ($s, $f) =@_;
 my @c;
 if (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-tn}->{-dbd}) eq 'dbi') {
     @c =('TRUNCATE TABLE ' .dbiTblExp1($s, $f));
     $s->logRec('dbiTrunc', @c);
     $s->dbi->do(@c) || return(&{$s->{-die}}($s->lng(0,'dbiTrunc') .": do() -> " .($DBI::errstr||'Unknown')) && undef);
 }
 elsif (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-tn}->{-dbd}) eq 'dbm') {
	my $n =$s->pthForm('dbm',($s->{-table}->{$f} && $s->{-table}->{$f}->{-expr} ||$f));
	if (-e $n) {
		$s->logRec('dbiTrunc','unlink', $n);
		unlink($n)
		|| return(&{$s->{-die}}($s->lng(0,'dbiTrunc') .": unlink('$n') -> $!") && undef)
	}
 }
 $s
}


sub recSel {    # Select records from database
		# see 'dbiSel'
 my	$s =$_[0];
 my	$a =@_< 3 && ref($_[1]) ? dsdClone($s, $_[1]) : {map {ref($_) ? dsdClone($s, $_) : $_} @_[1..$#_]};
	$a->{-table}=recType($s, $a, $a);
 my	$m =mdeTable($s,$a->{-table});
 local	$a->{-version}= ref($a->{-version})
			? $a->{-version}
			: $m && (!$a->{-version} ||$a->{-version} eq '-')
			? [ ($m->{-rvcActPtr}   ||$s->{-rvcActPtr}   ||())
			  ,@{$m->{-rvcDelState} ||$s->{-rvcDelState} ||[]}]
			: ($a->{-version} ||'+');
 local	$a->{-urole}= !$a->{-urole} ||($a->{-urole} eq 'all') ? undef : $a->{-urole};
#$s->logRec('recSel', $a);
 $s->{-fetched} =0;
 rmiTrigger($s, $a, undef, undef, qw(-recSel0C));
 my $r =$s->dbiSel($a);
 $r->{-query} =$a;
 $r
}


sub recList {	# List records from database
 recSel(@_)	# - reserved to be redesigned
}


sub recRead {   # Read one record from database
		# -key=>{field=>value}, see 'dbiSel'
		# -optrec=>boolean, -test=>boolean
 my	$s =$_[0];
 my	$a =@_< 3 && ref($_[1]) ? dsdClone($s, $_[1]) : {map {ref($_) ? dsdClone($s, $_) : $_} @_[1..$#_]};
 my	$d ={};
 local	$s->{-affect}=1;
	$a->{-table}=recType($s, $a, $d);
	$a->{-key}  =rmlKey($s, $a, $d);
	$a->{-data} =ref($a->{-data}) ne 'ARRAY' ? undef : $a->{-data};
 my	$m =mdeTable($s,$a->{-table});
 my	$r =undef;
 rmiTrigger($s, $a, $d, $r, qw(-recRead0C -recRead0R));
 $r =$s->dbiSel($a)->fetchrow_hashref();
 if ($r) {
	$s->{-affected} =1;
	$s->{-fetched}  =1;
 }
 else {
	$s->{-affected} =0;
	$s->{-fetched}  =0;
	return(undef)
		if $a->{-test};
 	return(&{$s->{-die}}($s->lng(0,'recRead') .': ' .($s->{-affected}||0) .' ' .$s->lng(1,'-affected')) && undef)
		if !$a->{-optrec}
		|| !$m->{-optrec};
	return($s->recNew(map {($_=>$a->{$_})} grep {$a->{$_}} qw(-table -form)));
 }
 if ($r && $s->{-rac}) {
	return(&{$s->{-die}}($s->lng(0,'recRead') .': '. $s->lng(1,'recReadAclStp')) && undef)
	if !$s->uadmrdr() 
	&&($m->{-racWriter} ||$s->{-racWriter} ||$m->{-racReader} ||$s->{-racReader})
	&& !$s->ugmember(map {$r->{$_}}	 @{$m->{-racWriter} ||$s->{-racWriter}||[]}
					,@{$m->{-racReader} ||$s->{-racReader}||[]});
	$r->{-editable} =$s->user()
		if $s->uadmwtr()
		|| $s->ugmember(map {$r->{$_}} @{$m->{-racWriter} || $s->{-racWriter}||[]})
 }
 rfdStamp($s, $a, $r) if $m->{-rfa} ||$s->{-rfa};
 rmiTrigger($s, $a, $r, undef, qw(-recForm0C)) if $r && $a->{-edit};
 rmiTrigger($s, $a, $d, $r, qw(-recRead1R -recRead1C -recForm1C)) if $r;
 $r
}



sub recLast {   # Last record lookup for values
		# self, table/command, record data, key fields,... target
 my	$s =$_[0];
 my	$d =$_[2];
 my	$a ={-table=>ref($_[1]) ? $s->recType($_[1], $d) : $_[1]};
 local	$s->{-affect}=1;
 my	$m =mdeTable($s,$a->{-table});
 my	$r =undef;
 return($r)
	unless ($m->{-dbd} ||$s->{-dbd} ||$s->{-tn}->{-dbd}) eq 'dbi';
 foreach my $c ($m, $s) {
	next if !$c->{-rvcUpdWhen}; 
	$a->{-order} =[[$c->{-rvcUpdWhen},'desc']];
	last
 }
 for (my $i =$#_; $i >2; $i--) {
	next if ref($_[$i]) ne 'ARRAY';
	$a->{-key} ={};
	for (my $j =3; $j <=$i; $j++) {
		foreach my $f (@{$_[$j]}) {
			next if !defined($d->{$f}) || ($d->{$f} eq '');
			$a->{-key}->{$f} =$d->{$f};
		}
	}
	next if !%{$a->{-key}};
	$s->logRec('recLast',$i,$s->strdata($a));
	rmiTrigger($s, $a, $d, $r, qw(-recRead0C -recRead0R));
	$r =$s->dbiSel($a)->fetchrow_hashref();
	next if !$r;
	# $s->{-affected} =$s->{-fetched} =1;
	rmiTrigger($s, $a, $d, $r, qw(-recRead1R -recRead1C));
	if	(ref($_[$#_]) eq 'CODE') {
		$r =$r && &{$_[$#_]}($s,$r);
	}
	elsif	(ref($_[$#_]) eq 'ARRAY') {
		foreach my $f (@{$_[$#_]}) {
			$d->{$f} =$r->{$f} if defined($r->{$f});
		}
	}
	last;
 }
 $r
}


sub dbiSel {    # Select records from database
		# -data		=>[fields] | [field, [field=>alias], {-fld=>alias, -expr=>formula,..}]
		# -table	=>[tables] | [[table=>alias], [table=>alias,join]]
		# -key		=>{field=>value}
		# -where	=>string   | [strings]
		# -ftext	=>string
		# -version	=>0|1
		# -order	=>string   | [field, [field=>order]]
		# -keyord	=>-(a|f|d|b)(all|eq|ge|gt|le|lt)
		# -group	=>string   | [field, [field=>order]]
		# -filter	=>sub{}(cursor, undef, {field=>value,...})
 my ($s, $a) =@_;
 my  $t =$a->{-table};
 my  $f =ref($t) ? $t->[0] : $t; $f =$1 if $f=~/^([^\s]+)/;
 my  @c;
 my  $r;
 if (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-tn}->{-dbd}) eq 'dbi') {
	# local $s->{-dbiph} =1 if !exists($s->{-dbiph});
	my @cn =!$a->{-key} ? () : $s->{-dbiph} ? sort keys %{$a->{-key}} : keys %{$a->{-key}};
	my @cv =!$a->{-key} ? () : $s->{-dbiph} ? map {ref($a->{-key}->{$_}) ? @{$a->{-key}->{$_}} : $a->{-key}->{$_}} @cn : ();
	my $kn =$s->{-table}->{$f} && $s->{-table}->{$f}->{-key} ||[];
	my $tf =$s->{-table}->{$f} && $s->{-table}->{$f}->{-mdefld};
	my $cf =$a->{-filter};
	@c =('SELECT '						# Data
		. (!$a->{-data}		? ' * '
		: !ref($a->{-data})	? ' ' .$a->{-data} .' '
		: ref($a->{-data}) ne 'ARRAY' ? ' * '
		: join(', '
			, map { my $v =ref($_) && $_ || $tf && $tf->{$_} || $_;
				!ref($v) 
				? $v
				: ref($v) ne 'HASH'
				? join(' AS ', @$v[0..1])
				: (defined($v->{-expr}) 
					? $v->{-expr} .' AS ' .$v->{-fld} 
					: $v->{-fld})
				} @{$a->{-data}}))
		. ' FROM '					# From
		. (ref($t) 
			? join(' '
				, (map {!ref($_) 
					? ($_,',') 
					: (@$_, $_->[$#_] =~/(JOIN|,)$/i 
						? () 
						: ',')} @$t)[0..-1])
			: dbiTblExpr($s, $t)
			)
		. ' WHERE '					# Where
		. join(' AND '
			, dbiKeyWhr($s, $a, @cn)		# Key condition
			,($a->{-where}				# Where condition
			? '(' .(!ref($a->{-where}) 
				? $a->{-where} 
				: join(' AND ', map {$_
					} @{$a->{-where}})) 
			  .')'
			: ())
			,(ref($a->{-version})			# Version switch
			? ('((' .$f .'.' .$a->{-version}->[0]
				.' IS NULL OR ' .$f .'.' .$a->{-version}->[0] 
				."='')"
				.($a->{-version}->[1]
					? " AND $f."
						.$a->{-version}->[1] ." <> '"
						.$a->{-version}->[2] ."')"
					: ')'))
			: ())
			,(($a->{-urole} && !$a->{-uname})	# Access control
			|| $s->uadmrdr()
			? ()
			: dbiACLike($s, $f, undef
				, mdeReaders($s, $f), $s->ugnames(), $cf))
			,(!$a->{-urole}				# Role filter
			? ()
			: dbiACLike($s, $f, undef
				, mdeRole($s, $f, $a->{-urole})
				,($a->{-uname}
				? $s->ugnames($a->{-uname})
				: $s->ugnames())
				, $cf))
			,(!$a->{-urole}
			? ()
			: $a->{-urole} =~/^(?:principal|user)$/i
			? dbiACLike($s, $f, 'NOT'
				, mdeRole($s, $f, 'actor')
				,($a->{-uname}
				? $s->ugnames($a->{-uname})
				: $s->ugnames())
				, $cf)
			: $a->{-urole} =~/^(?:principals|users)$/i
			? dbiACLike($s, $f, 'NOT'
				, mdeRole($s, $f, 'actors')
				,($a->{-uname}
				? $s->ugnames($a->{-uname})
				: $s->ugnames())
				, $cf)
			: ())
			,(!$a->{-ftext}				# Full-text
			? ()
			: ref($a->{-data} eq 'ARRAY')
			? '(' .join(' OR '
				, map {(!ref($_) 
					? $_ 
					: ref($_) ne 'HASH'
					? $_->[1]
					: $_->{-fld})
					. ' LIKE ' 
					.$s->dbi->quote('%' .$a->{-ftext} .'%')
					} grep {$_ && (ref($_) ne 'HASH' || $_->{-fld})
						} @{$a->{-data}}
				, $s->{-table}->{$f}->{-ftext}
				? map {	$_
					. ' LIKE ' .$s->dbi->quote('%' .$a->{-ftext} .'%')
					} @{$s->{-table}->{$f}->{-ftext}}
				: ()
			  ) .')'
			: $s->{-table}->{$f}->{-ftext}
			? '(' .join(' OR '
				, map {	$_
					. ' LIKE '. $s->dbi->quote('%' .$a->{-ftext} .'%')
					} @{$s->{-table}->{$f}->{-ftext}}
			  ) .')'
			: $s->{-table}->{$f}->{-field}
			? '(' .join(' OR '
				, map {	$_->{-fld}
					. ' LIKE ' .$s->dbi->quote('%' .$a->{-ftext} .'%')
					} grep {ref($_) eq 'HASH' && $_->{-fld} && ($_->{-flg}||'') =~/[akwuql]/
						} @{$s->{-table}->{$f}->{-field}}
			  ) .')'
			: ())
			,(scalar(@cn) ||$a->{-where} ||ref($a->{-version})
				||$a->{-urole} ||$a->{-ftext} 
			? () 
			: ('1=1')) # !!! TRUE may be?
			)
		. ($a->{-group}					# Group by
		  ? ' GROUP BY '
			.(ref($a->{-group})
			? join(', ', map {!ref($_) ? $_ : join(' ',@$_)} @{$a->{-group}})
			: $a->{-group})
		  : '')
		. ($a->{-order}					# Order by
		  ? ' ORDER BY '
			.(ref($a->{-order})
			? join(', '
				,map {	  ref($_) 
					? join(' ',@$_) 
					: $_ !~/[\s,]/
					? $_ .($a->{-keyord} && ($a->{-keyord} =~/^-[db]/) ? ' desc' : '')
					: $_
					} @{$a->{-order}})
			: $a->{-order} =~/^-[db]/
			? join(',', map {"$_ desc"} @$kn)
			: substr($a->{-order},0,1) eq '-' # $a->{-order}=~/^-[af]/
			? join(',', @$kn)
			: $a->{-order} !~/[\s,]/
			? $a->{-order} .($a->{-keyord} && ($a->{-keyord} =~/^-[db]/) ? ' desc' : '')
			: $a->{-order})
		  : $a->{-keyord}				# -keyord
		  ? ' ORDER BY '
			.($a->{-keyord} =~/-[db]/
			? join(',', map {"$_ desc"} @$kn)
			: join(',', @$kn))
		  : '')
		. ($a->{-having}				# Having
		  ? ' HAVING ' .$a->{-having}
		  : ''
		. ($a->{-limit}					# Limit
		  && $s->dbi->{Driver}->{Name} eq 'mysql'
		  ? ' LIMIT ' .$a->{-limit}
		  : '')
		)
	);
	$s->logRec('dbiSel', @c, @cv ? {} : (), @cv);
	$r =$s->dbi->prepare(@c) || return(&{$s->{-die}}($s->lng(0,'dbiSel') .": prepare() -> " .($DBI::errstr||'Unknown')) && undef);
	$r->execute(@cv) || return(&{$s->{-die}}($s->lng(0,'dbiSel') .": execute() -> " .($DBI::errstr||'Unknown')) && undef);
	$r =DBIx::Web::dbiCursor->new($r, -flt=>$cf) 
		if $cf || 1;	# !!! DBI::st hides keys !!!
	$r->{-rec} ={map {($_ => undef)} @{$r->{NAME}}};
	$r->{-rfr} =[map {\($r->{-rec}->{$_})} @{$r->{NAME}}];
	$r->{-flt} =$cf;
	$r->bind_columns(undef, @{$r->{-rfr}});
	$s->dbiExplain(@c) if $s->{-debug} && $s->dbi->{Driver}->{Name} eq 'mysql';
 }
 elsif (($s->{-table}->{$f}->{-dbd} ||$s->{-dbd} ||$s->{-tn}->{-dbd}) eq 'dbm') {
	$r =$s->dbmSeek($a);
	return(&{$s->{-die}}($s->lng(0,'dbiSel') .": dbmSeek() -> $@") && undef) if !defined($r);
	if	($a->{-data} && (ref($a->{-data}) eq 'ARRAY')) {
		$r->setcols($a->{-data})
	}
	elsif	(my $m =$s->{-table}->{$f}->{-field}) {
		$r->setcols(ref($m) eq 'HASH' 
			? keys %$m
			: map {$_->{-fld}} grep {(ref($_) eq 'HASH') && $_->{-fld}} @$m)
	}
 }
 $r
}


sub recCommit {	# commit changes in the database
 $_[0]->logRec('recCommit');
 if ($_[0]->{-dbi}) {
	$_[0]->{-dbi}->commit 
	|| return(&{$_[0]->{-die}}($_[0]->lng(0,'recCommit') .": commit() -> " .($DBI::errstr||'Unknown')) && undef)
 }
 $_[0]
}


sub recRollback {# rollback changes in the database
 $_[0]->logRec('recRollback');
 if ($_[0]->{-dbi}) {
	$_[0]->{-dbi}->rollback
	|| return(&{$_[0]->{-die}}($_[0]->lng(0,'recRollback') .": rollback() -> " .($DBI::errstr||'Unknown')) && undef)
 }
 $_[0]
}


#########################################################
# CGI User Interface
#########################################################


sub cgiRun {	# Execute CGI query
 my $s =$_[0];
 my $r;
 local($s->{-pcmd}, $s->{-pdta}, $s->{-pout});
		# Automatic upgrade
 if ($s->{-setup} && !$ARGV[0]) {
 	my $ds =(stat(main::DATA))[9] ||0;
	my $dv =($ds && (stat($s->varFile()))[9])||0;
	$ARGV[0] ='-setup' if $ds >$dv;
 }
		# Command line service options
 if ($ARGV[0]) {
	$s->start();
	print "Content-type: text/plain\n\n";
	print "'$0' service operation: '" .$ARGV[0] ."'...\n";
	if ($ARGV[0] eq '-reindex') {
		$r =$s->recReindex(1);
	}
	elsif ($ARGV[0] eq '-setup') {
		$r =$s->setup();
		$s->varStore();
	}
	# print "'$0' service operation: '" .$ARGV[0] ."'->$r\n";
	return($s)
 }
		# Error display handler
 my $he =sub{
	return if $^S;
	delete $s->{-pcmd}->{-xml} if $s->{-pcmd};
	my $e =$_[0]; chomp($e);
	eval{$s->logRec('Die', $e)};
	eval{$s->recRollback()};
	eval{$s->htmlStart()} if !*fatalsToBrowser && !$s->{-c}->{-httpheader};
	eval{ # $e =htmlEscape($s, $e);
		$e =~s/[\n\r]/<br \/>\n/g;
		$s->output('<span class="ErrorMessage"><hr class="ErrorMessage" />'
		,'<h1 class="ErrorMessage">', 'Error '
		, htmlEscape($s, lng($s, 0, ($s->{-pcmd} && $s->{-pcmd}->{-cmd})||'Open'))
		, '@'
		, htmlEscape($s, lng($s, 0, ($s->{-pcmd} && $s->{-pcmd}->{-cmg})||'Start'))
		, "</h1>\n"
		, $e, "</span>\n");
	     $s->cgiFooter();
	     $s->output("<hr />\n")};
	eval{$s->end()};
	};
 if (*fatalsToBrowser)	{$SIG{__DIE__} ='DEFAULT'; !*CGI::Carp::set_message{CODE} && eval('use CGI::Carp'); CGI::Carp::set_message($he)}
 else			{$SIG{__DIE__} =$he}

		# Start operation
 $s->start();
 $s->set(-autocommit=>0);
 local $s->{-affect} =1;

 # cmg transitions:
 # global       commands
 # -------      --------
 # recList:	recList,	  recForm, recQBF->
 # recQBF:	recQBF,  	  recForm, recList->
 # recNew:	recNew,  	  recForm, recIns->
 # recRead:	recRead, recEdit, recForm, recIns, recUpd, recDel->, recNew->
 # recDel:			  recForm
 # recForm?			  recForm

		# Accept & parse CGI params, find form, command, global command, key...
 $s->cgiParse();
 my $oa =$s->{-pcmd}->{-cmd};
 my $og =$s->{-pcmd}->{-cmg};
 my $on =$s->{-pcmd}->{-form} ||'default';
 my ($om, $oc);

		# Login redirection, if needed
 if ($s->{-pcmd}->{-login} && $s->uguest()) {
	print $s->cgi->redirect(-uri=>$s->urlAuth(), -nph=>(($ENV{SERVER_SOFTWARE}||'') =~/IIS/) ||($ENV{MOD_PERL} && !$ENV{PERL_SEND_HEADER}));
	$s->end();
	return($s);
 }

 while(1) {	# Determine / Delegate operation object requested / Execute
	if	($s->{-form}  && $s->{-form}->{$on})	{$oc ='f'; $om =$s->{-form}->{$on}}
	elsif	($s->{-table} && $s->mdeTable($on))	{$oc ='t'; $om =$s->mdeTable($on)}
	else						{$oc ='' ; $om =undef}
	return(&{$s->{-die}}($s->lng(0,'cgiRun') .": Operation object '$on' not found") && undef) if !$om;
	$s->{-pcmd}->{-table} =($oc eq 't' ? $on : $om->{-table});

					# redirectional implemtation: '-cgcURL'
	foreach my $e (map {$om->{$_}} ('-cgcURL', '-redirect')) {
		next if !defined($e);
		last if !$e;
		print $s->cgi->redirect(-uri=>$e, -nph=>(($ENV{SERVER_SOFTWARE}||'') =~/IIS/) ||($ENV{MOD_PERL} && !$ENV{PERL_SEND_HEADER}));
		$s->end();
		return($r);
	}
					# external implemtation: '-cgcXXX'
	foreach my $e (map {$om->{"-cgc$_"}}
			 $oa =~/^rec(.+)/ ? $1 : $oa
			,$og =~/^rec(.+)/ ? $1 : $og, 'Call') {
		next if !defined($e);
		last if !$e;
		$_ =$s;
		$r =	ref($e) 
			? &$e($s, $on, $om, $s->{-pcmd}, $s->{-pdta})
			: $e =~/\.psp$/i
			? $s->psEval('-', $e, undef, $on, $om, $s->{-pcmd}, $s->{-pdta})
			: do($e);
		$s->end();
		return($r)
	}

	my $nxt;			# delegation - substitute object
	foreach my $v (map {$om->{"-$_"}} ('subst', $oa
			, $oa eq 'recList' && $og eq 'recQBF'
			? ('recQBFl')	# !!! legacy from '-qlist', needed ???
			: $og =~/rec(New|Read|Del|QBF)/ 
			? ($og, 'recForm') 
			: $og)) {
		next if !defined($v) || ref($v);
		last if !$v;
		$on = $nxt =$v;
		last
	}
	next if $nxt;
	last;
 }

		# Execute action
 if	(ref(my $e =$om->{"-$oa"}) eq 'CODE') {
	$s->{-pout} =&$e($s, $on, $om, $s->{-pcmd}, $s->{-pdta});
 }
 else	{
	$s->{-pout} =$s->cgiAction($on, $om, $s->{-pcmd}, $s->{-pdta});
 }

		# Reassign form if changed
 $s->{-pcmd}->{-form} =(isa($s->{-pout}, 'HASH') && $s->{-pout}->{-form})
			|| $s->{-pcmd}->{-form} ||$on;

		# Execute external presentation '-cgvXXX'
 foreach my $e (map {$om->{"-cgv$_"}}
		 $oa =~/^rec(.+)/ ? $1 : $oa
		,$og =~/^rec(.+)/ ? $1 : $og, 'Call') {
	next if !defined($e);
	last if !$e;
	$_ =$s;
	$r =	  ref($e)
		? &$e($s, $on, $om, $s->{-pcmd}, $s->{-pout})
		: $e =~/\.psp$/i 
		? $s->psEval('-', $e, undef, $on, $om, $s->{-pcmd}, $s->{-pout})
		: do($e);
	$s->end();
	return($r);
 }

		# Execute predefined presentation implementation
 $s->output(
	 $s->htmlStart($s->{-pcmd}->{-form}, $om)	# HTTP/HTML/Form headers
	,$s->htmlHidden($s->{-pcmd}->{-form}, $om)	# common hidden fields
	,$s->htmlMenu($on, $om)				# Menu bar
	);
 $s->cgiForm($on, $om, $s->{-pcmd}, $s->{-pout}) if $s->cgiHook('recFormRWQ');
 $s->cgiList($on, $om, $s->{-pcmd}, $s->{-pout}) if $s->cgiHook('recList');
 $s->recCommit();
 $s->cgiFooter();
 $s->htmlEnd();
 $s->end();
 $s
}


sub cgiParse {	# Parse CGI call parameters
 my ($s) =@_;
 my $g =$s->cgi;
 my $d =$g->Vars;
 $s->{-pcmd} ={};
 $s->{-pdta} ={};
 $s->{-lng} =$g->http('Accept_language')||'';
 $s->set(-lng =>lc($s->{-lng} =~/^([^ ;,]+)/ ? $1 : $s->{-lng}));
 foreach my $k (keys %$d) {
	next if !defined($d->{$k} || $d->{$k} eq '');
	if($k =~/^_(quname)__S$/) {		# cgiDDLB choise
		$s->{-pcmd}->{"-$1"} =$d->{'_' .$1 .'__L'};
	}
	if($k =~/^(.+)__S$/) {			# cgiDDLB choise
		$s->{-pdta}->{$1} =$d->{$1 .'__L'};
		$s->{-pdta}->{$k} =$d->{$k};
	}
	elsif($k =~/^_(new|file)$/) {		# record attribute
		$s->{-pdta}->{"-$k"} =$d->{$k}
	}
	elsif ($k =~/^_(cmd|cmg|frmCall|frmName\d*|frmLso|frmLsc|recNew|recRead|recPrint|recXML|recEdit|recIns|recUpd|recDel|recForm|recList|recQBF|submit.*|app.*|form|key|urm|qkey|qwhere|qurole|quname|qftext|qversion|qorder|qkeyord|qlist|qlimit|qftwhere|qftord|qftlimit|edit|backc|login|print|refresh|xml|style)(?:\.[xXyY]){0,1}$/i) {
		my ($c, $v) =($1, $d->{$k});	# command
		$v =$1	if ($k !~/^_(key|qkey|qftext)/i)
			&& ($v =~/^\s*(.+?)\s*$/);
		if ($k =~/^(.+)\.[xXyY]$/) {
			$g->param($1, 1);
			$g->delete($k);
			$v=1;
		}
		if ($c =~/^(?:rec|frmCall|submit)/i) {
			$s->{-pcmd}->{-cmd} =$c
		}
		else {
			$s->{-pcmd}->{"-$c"}=$v
		}
	}
	else {					# data
		$s->{-pdta}->{$k} =$d->{$k}
	}
 }
 my $c =$s->{-pcmd};

 $c->{-cmg} ='recList' 
		if !$c->{-cmg} && !$c->{-cmd};
 $c->{-cmd} =!$c->{-cmg}? 'frmCall' 
			: $c->{-cmg} eq 'recList' ? 'recList' : 'recForm'
		if !$c->{-cmd};
 $c->{-cmg} =$c->{-cmd} eq 'recForm' ? 'recList' : $c->{-cmd}
		if !$c->{-cmg};

 map {$c->{$_} =datastr($s, $c->{$_})
	} grep {$c->{$_}} qw(-key -qkey);
 $c->{-key} =$s->rmlKey($c, $s->{-pdta})
		if $c->{-key} && !ref($c->{-key}) && $s->{-idsplit};
 $c->{-form}=$c->{-table} 
		if !$c->{-form} && $c->{-table};

 if ($c->{-frmLso} && $c->{-frmLso} eq 'recQBF') {
	$c->{-cmd} =$c->{-frmLso};
	delete $c->{-frmLso};
	$g->delete('_frmLso');
 }
 if	($c->{-cmd} eq 'frmCall') {
	my $frm =($c->{-frmName1} ||$c->{-frmName} ||$c->{-form} ||'default');
	$c->{-cmd}  =$c->{-cmg} =($frm =~/[+]+\s*$/
				? 'recNew'
				: $frm =~/[&.]+\s*$/
				? 'recForm'
				: 'recList');
	$frm =($frm=~/^(.+)(?:\s*[+&.]+\s*)$/ ? $1 : $frm);
	if ($frm ne ($c->{-form}||'')) {
			# !!! query parameters for current view only, not table
		map {delete $c->{$_}} qw (-frmLso -frmLsc -qkey -qwhere -qurole -quname -qversion -qorder -qkeyord);
		$g->delete('_frmLso');
		delete $c->{-key}
			if ($c->{-cmd} eq 'recList')
			|| ($c->{-cmg} eq 'recList');
		$c->{-backc} =0;
	}
	$c->{-form}  =$frm;
 }

 if	($c->{-cmd} eq 'recNew') {
	$c->{-edit} =1;
	$c->{-backc}=0;
 }
 elsif	($c->{-cmd} eq 'recEdit') {
	$c->{-edit} =1;
	$c->{-cmd}  ='recRead'
 }
 elsif	($c->{-cmd} eq 'recPrint') {
	$c->{-print} =1;
	$c->{-cmd}  ='recRead'
 }
 elsif	($c->{-cmd} eq 'recXML') {
	$c->{-xml} =1;
	$c->{-cmd} =$c->{-cmg} ||'recRead';
	$c->{-cmd} ='recList' if $c->{-cmd} eq 'recXML';
 }
 elsif	($c->{-cmd} !~/^(recIns|recUpd|recForm)/) {
	$c->{-edit} =undef
 }

 if	($c->{-cmd} =~/recList/ && $c->{-key}) {
	$c->{-qkey} =$c->{-key};
	delete $c->{-key};
 }

 if	($c->{-cmd} =~/recList/ and $c->{-cmg} =~/recQBF/) {
	$c->{-qkey} =$s->cgiQKey($c->{-form}, undef, $s->{-pdta});
	$c->{-qkey} =undef if !%{$c->{-qkey}};
	$c->{-form}=$c->{-qlist} || $c->{-form};
	$c->{-backc}=0;
 }
 elsif	($c->{-cmd} =~/recQBF/ && $c->{-cmg} =~/recList/) {
	$c->{-edit} =1;
        $s->{-pdta} ={};
 	map {$s->{-pdta}->{$_} =$c->{-qkey}->{$_}
		} grep { defined($c->{-qkey}->{$_}) && $c->{-qkey}->{$_} ne ''
			} keys %{$c->{-qkey}} if $c->{-qkey};
	$c->{-qlist}=$c->{-form};
	$c->{-backc}=0;
 }

 if ($c->{-cmd} !~/recList/) {
	delete $c->{-refresh};
 }
 $c->{-backc} =(    ($c->{-cmd} eq 'recForm')
		||  ($c->{-cmd} eq 'recIns')
		|| (($c->{-cmd} eq 'recRead') || ($c->{-cmg} eq 'recRead'))
		|| (($c->{-cmd} eq 'recList') || ($c->{-cmg} eq 'recList'))
		? ($c->{-backc}||0) +1
		: 1);
 $c->{-cmh} =$c->{-cmg};		# history general command
 $c->{-cmg} =$s->cgiHook('cmgNext');	# actual  general command
 $s
}


sub cgiHook {	# HTML generation hook condition
 $_[0]->cgiParse() if !$_[0]->{-pcmd}->{-cmd};
 my $c =$_[0]->{-pcmd};
 return($c->{-cmd}) if !$_[1];
   ($_[1] eq $c->{-cmd})		# current operation
 ? $c->{-cmd}
 : ($_[1] eq 'recOp')			# record operation (exept 'recList')
	&& ($c->{-cmd} =~/^rec(New|Form|Read|Edit|Ins|Upd|Del)/)
 ? $c->{-cmd}
 : ($_[1] eq 'appOp')			# application operation ???
	&& ($c->{-cmd} =~/^app/)
 ? $c->{-cmd}
 : ($_[1] eq 'cmgNext')			# next global command to output as hidden
 ? (      $c->{-cmd} eq 'recForm' 
	? $c->{-cmg}
	: (grep {$c->{-cmd} eq $_} qw(recIns recUpd))
	? 'recRead'
	: $c->{-cmd} eq 'recDel'
	? $c->{-cmd}
	: $c->{-cmd})
 : ($_[1] eq 'recMenu')			# generate HTML above form or list ???
	&&($c->{-cmd} !~/app|Help/)
 ? $c->{-cmd}
 : ($_[1] =~/^recForm/)			# generate HTML form of record
	&&($c->{-cmd} !~/app|Help/)
	&&( $_[1] !~/^recForm([RWDQL]+)/
	 ||($_[1] =~/[WR]/ && $c->{-cmg} =~/^rec(Form|Read)/)
	 ||($_[1] =~/[W]/  && $c->{-cmg} =~/^rec(New|Form|Read|Ins|Upd)/)
	 ||($_[1] =~/[D]/  && $c->{-cmg} =~/^rec(Del)/)
	 ||($_[1] =~/[Q]/  && $c->{-cmg} eq 'recQBF')
	 ||($_[1] =~/[L]/  && $c->{-cmg} eq 'recList')
	  )
 ? $c->{-cmd}
 : ($_[1] eq 'recList')			# generate HTML list of records
	&& ($c->{-cmd} eq 'recList')
 ? $c->{-cmd}
 : ($_[1] eq 'recCommit')		# commit database operation
	&& ($c->{-cmd} =~/^rec(New|Form|Read|Ins|Upd|Del|List)/)
 ? $c->{-cmd}
 : ''
}


sub urlAuth {	# Login URL
 my $s =$_[0];
 my $u =$s->{-login};
 if ($u =~/\/$/) {
	my $u0=$u;
	my $u1=$s->cgi->self_url;	#url(-absolute=>1);
	   $u1=($u1=~/^\w+:\/\/[^\/]+(.+)/ ? $1 : $u1);
	my $i;
	while (($i =index($u0, '/')) >=0 and substr($u0,0,$i) eq substr($u1,0,$i)) {
		$u0 =substr($u0, $i+1); $u1 =substr($u1, $i+1);
	}
	$u .=$u1
 }
 $u
}


sub urlOpt {	# Option URL
 my $s =$_[0];
 my %v =();
 for (my $i =1; $i <$#_; $i+=2) {
	next if !defined($_[$i+1]) ||($_[$i+1] eq '');
	$v{$_[$i] =~/^-/ ? '_' .substr($_[$i],1) : $_[$i]}
		=ref($_[$i+1]) ? $s->strdata($_[$i+1]) : $_[$i+1];
 }
 $s->urlCat($s->cgi->url
	,(map {	my $n =$_;
		defined($s->{-pcmd}->{$_})
		&& ($s->{-pcmd}->{$_} ne '')
		&& ($n =$_ =~/^-/ ? '_' .substr($_,1) : $_)
		&& ($n !~/_(?:frmName|cmg|cmh|backc)/i)
		&& !exists($v{$n})
		? ($n =>  (ref($s->{-pcmd}->{$_}) 
			? $s->strdata($s->{-pcmd}->{$_}) 
			: $s->{-pcmd}->{$_}))
		: ()} keys %{$s->{-pcmd}})
	,%v)
}


sub psParse {	# PerlScript Parse Source
 my $s  =shift;	# (?options, perl script source, base URL)
 my $opt=substr($_[0],0,1) eq '-' ? shift : '-';
 my $i  =$_[0];	# input source
 my $b  =$_[1];	# base URL
 my $o  ='';	# output source
 my ($ol,$or) =('','');
 my ($ts,$tl,$ta,$tc) =('','','','');
 if ($i =~/<(!DOCTYPE|html|head)/i && $`) {
     $i ='<' .$1 .$'
 }
 if ($b && $i =~m{(<body[^>]*>)}i) {
     my ($i0,$i1) =($` .$1 ,$');
     $i =$i0 .('<base href="'. $s->urlEscape($b) .'/" />') .$i1
 }
 if ($opt =~/e/i && $i =~m{<body[^>]*>}i) {	# '-e'mbeddable html
    $i =$';
    $i =$` if $i =~m{</body>}i
 }
 while ($i) {
    if (not $i =~m{<(\%@|\%|SCRIPT) *(Language *= *|)* *(PerlScript|Perl|)* *(RUNAT *= *Server|)*[ >]*}i) {
       $ol =$i; $i ='';
       $ts ='';
    }
    elsif (($2 && !$3) || (!$3 && $tl eq '1')) {
       $ol =$` .$&;
       $i  =$';
       $tl =1;
       $tc =$ts ='';
    }
    elsif ($1) {
       $ol =$`; $i =$';
       $ts =uc($1||''); $tl =($2 && $3)||''; $ta=$4||'';
       if ($i =~m{ *(\%>|</SCRIPT>)}i) {$tc =$`; $i =$'}
       else                            {$tc =''}
    }
    else {
       $ol =$i; $i ='';
    }
    $ol =~s/(["\$\@%\\])/\\$1/g;
    $ol =~s/[\n]/\\n");\n\$_[0]->output("/g;
    $o .= "\$_[0]->output(\"$ol\\n\");\n";
    next if !$ts || !$tc || $ts eq '%@';
    $tc =~s/\&lt;?/</g;
    $tc =~s/\&gt;?/>/g;
    $tc =~s/\&amp;?/\&/g;
    $tc =~s/\&quot;?/"/g;
    if    ($ts eq '%')      { $o .= "\$_[0]->output($tc);\n" }
    elsif ($ts eq 'SCRIPT') { $o .= $tc .";\n"}
 }
 $o;
}


sub psEval {	# Evaluate perl script file
 my $s =shift;	# (?options, filename, ?base URL,...)
 my $o =substr($_[0],0,1) eq '-' ? shift : '-';
 my $f =shift;		# filename
 my $u =shift;		# base URL
 my $c =undef;		# code
 if ($f !~/^(\/|\w:[\\\/])/ && !-e $f) {
	$f =$s->{-path} .'/psp/' .$f;
	$u =$s->{-url}  if !$u;
 }
 $s->hfNew($f)->read($c, -s $f)->close();
 $s->output($s->{-c}->{-httpheader} =$s->cgi->header(
		  -charset => $s->{-charset}, -expires => 'now'
		, ref($s->{-httpheader})
		? %{$s->{-httpheader}}
		: ()))
          if $o !~/e/;  # '-e'mbeddable html
 local $SELF =$s;
 $c =eval('sub{' .$s->psParse($o, $c, $u, @_) .'}');
 eval{&$c($s, $o, $f, @_)};
 return(&{$s->{-die} }("psEval($o, $f)->$@") && undef) if $@;
 $s
}


sub cgiAction {	# cgiRun Action Executor encapsulated
		# self, obj name, ?obj meta, ?command, ?data
 my ($s, $on, $om, $oc, $od) =@_;
    $om =$s->{-form}->{$on}||$s->mdeTable($on) if !$om;
    $oc =$s->{-pcmd} if !$oc;
    $od =$s->{-pdta} if !$od;
 my $oa =$s->{-pcmd}->{-cmd};
 my $og =$oc->{-cmg};
 my $ot =$oc->{-table};
 if	($ot && $oa =~/^rec/) {
	if	($oa =~/^recList/) {
		$s->{-pout} =$s->cgiQuery($on, $om)
	}
	elsif	($oa =~/^recQBF/ ||$og =~/^rec(?:List|QBF)/) {
		$s->{-pout} ={%{$od}}
	}
	elsif	($oa =~/^rec(?:Read)/) {
		$s->{-pout} =$s->recRead(-table=>$ot
				, ref($om->{-recRead}) eq 'HASH' ? %{$om->{-recRead}} : ()
				, map {($_=>$oc->{$_})
				} grep {defined($oc->{$_}) 
					&& $oc->{$_} ne ''
					}  qw(-key -form));
	}
	else {
		$s->rmiTrigger($oc, $od, undef, qw(-recTrim0A))
			if $oa =~/^rec(?:New|Form|Ins|Upd|Del)/;
		$s->rmiTrigger($oc, $od, undef, qw(-recChg0A))
			if $oa =~/^rec(?:Form|Ins|Upd|Del)/;
		$s->{-pout} =$s->$oa(-data=>$s->cgiDBData($on, $om, $oc, $od)
				, -table=>$ot
				, $oa =~/^rec(?:Upd|Del)/ ? (-version =>'+') : ()
				, map {($_=>$oc->{$_})
				} grep {defined($oc->{$_}) 
					&& $oc->{$_} ne ''
					}  qw(-key -form -edit));
	}
	$oc->{-key} =$s->recWKey($ot, $s->{-pout})
		if $oa =~/^rec(?:Read|Ins|Upd)/
		&& $oc->{-edit};
	$s->{-pout} =$s->recRead(-table=>$ot
			, %{$om->{-recRead}}
			, -key=>$oc->{-key})
		if ref($om->{-recRead}) eq 'HASH'
		&& $oa =~/^rec(?:Ins|Upd)/;
	delete $oc->{-edit}
		if $oc->{-edit}
		&& $oa =~/^rec(?:Ins|Upd|Del)/;
	$s->rmiTrigger($oc, $s->{-pout}, undef, qw(-recChg0A))
		if $oc->{-edit} && ($oa =~/^rec(?:Read|New)/);
	$s->rmiTrigger($oc, $od, $s->{-pout}, qw(-recChg1A))
		if $oa =~/^rec(?:Ins|Upd)/;
 }
 elsif	($oa =~/^(recForm)/) {
	# nothing needed
 }
 else	{
	return(&{$s->{-die}}($s->lng(0,'cgiRun') .": Action '$oa\@$og' not found") && undef)
 }
 $s->{-pout}
}


sub htmlStart {	# HTTP/HTML/Form headers
 my ($s,$on)=@_;
 $on =$s->{-pcmd}->{-form} ||$s->{-pcmd}->{-table} ||'default'
	if !$on;
 my $r	=join(""
	, $s->{-c}->{-httpheader} =$s->cgi->header(
		-charset => $s->{-charset}, -expires => 'now'
		, ref($s->{-httpheader}) 
		? %{$s->{-httpheader}} 
		: ()
		, $s->{-pcmd}->{-xml}
		? (-type => 'text/xml')
		: ()
		)
	, $s->{-c}->{-htmlstart}  =
		  $s->{-pcmd}->{-xml}
		? (ref($s->{-xmlstart})
			? $s->xmlsTag($s->{-xmlstart})
			: ($s->{-xmlstart} 
			||('<?xml version="1.0"'
				.(!$s->{-charset}
				 ? ''
				 : $s->{-charset} =~/^\d/
				 ? ' encoding="windows-' .$s->{-charset} .'"'
				 : ' encoding="' .$s->{-charset} .'"')
			  .' ?>'))
		  .($s->{-pcmd}->{-style}
		   ? '<?xml:stylesheet href="' .$s->{-pcmd}->{-style} .'" type="text/css" ?>'
		   : '')
		  )
		: $s->cgi->start_html(
			 -head	=> '<meta http-equiv="Content-Type" content="text/html; charset=' .$s->{-charset} .'">'
				.($s->{-pcmd}->{-refresh} ? '<meta http-equiv="refresh" content=' .$s->{-pcmd}->{-refresh} .'>' : '')
			,-lang	=> $s->{-lang}
			,-title	=> $s->{-title} ||$s->cgi->server_name()
			,-class	=> (	  $s->cgiHook('recOp')
					? 'Form' .($on ? ' ' .$on : '')
					: $s->cgiHook('recFormQ')
					? 'Form' .($on ? ' ' .$on : '') 
						 .' QBF' .($on ? ' ' .$on .'__QBF' : '')
					: $s->cgiHook('recHelp')
					? 'Form Help'
						 .($on ? ' ' .$on .'__Help' : '')
					: 'Form' .($on ? ' ' .$on : '') 
						 .' List' .($on ? ' ' .$on .'__List' : ''))
			,ref($s->{-htmlstart}) 
			? %{$s->{-htmlstart}} 
			: ()
			,$s->{-pcmd}->{-style}
			? (-style=>{'src'=>$s->{-pcmd}->{-style}})
			: ())
	, "\n"
	, $s->{-pcmd}->{-xml}
		? $s->xmlsTag($s->{-pcmd}->{-form}||'default'
			, (map { defined($s->{-pcmd}->{$_}) && ($s->{-pcmd}->{$_} ne '')
				? ((substr($_,0,1) eq '-' ? substr($_,1) : $_)
				 ,$s->{-pcmd}->{$_})
				: ()
				} sort keys %{$s->{-pcmd}})
			, 'xmlns'=>$s->cgi->url
			, '0')
		: $s->cgi()->start_multipart_form(-method=>($s->{-pcmd}->{-refresh} ? 'get' : 'post'))) ."\n";
 eval{warningsToBrowser(1)} if *warningsToBrowser;
 $r;
}


sub htmlEnd {	# End of HTML/HTTP output
 my ($s) =@_;
 if ($s->{-pcmd}->{-xml}) {		
	$s->output("\n</" .$s->xmlTagEscape($s->{-pcmd}->{-form}||'default') .">\n")
 }
 else {
	$s->output($s->cgi()->endform(), $s->cgi()->end_html())
 }
}


sub htmlHidden {# Common hidden fields
 my ($s, $on, $om) =@_;
 return('') if $s->{-pcmd}->{-xml} ||$s->{-pcmd}->{-print};
 join("\n"
	,'<input type="hidden" name="_form" value="' .$s->htmlEscape($on) .'" />'
	,'<input type="hidden" name="_cmd"  value="" />'
	,'<input type="hidden" name="_cmg"  value="' .$s->htmlEscape($s->{-pcmd}->{-cmg}) .'" />'
	,(map { !defined($s->{-pcmd}->{"-$_"}) || ($s->{-pcmd}->{"-$_"} eq '')
		? ()
		: ('<input type="hidden" name="_' .$_ .'" value="'
		  .$s->htmlEscape(!defined($s->{-pcmd}->{"-$_"})
			? ''
			: ref($s->{-pcmd}->{"-$_"})
			? strdata($s, $s->{-pcmd}->{"-$_"})
			: $s->{-pcmd}->{"-$_"})
		  .'" />')
		} (qw(edit backc key style)
		, $s->{-pcmd}->{-cmg} ne 'recQBF'
		? qw(qkey qwhere qurole quname qversion qorder qkeyord qlimit)
		: qw(qlist)	))
	) ."\n"
}


sub htmlMenu {	# Screen menu bar
 my ($s,$on,$om) =@_;
 return('') if $s->{-pcmd}->{-xml} ||$s->{-pcmd}->{-print};
 my $ot=$om && $om->{-table} && $s->mdeTable($om->{-table}) || $om;
 my $c =$s->{-pcmd};
 my $a =$c->{-cmd};
 my $g =$c->{-cmg};
 my $e =$c->{-edit};
 my $d =$s->{-pdta};
 my $n =$d->{-new} ||($c->{-cmg} eq 'recNew');
 my @r =();
 if	(1) {				# 'back' js button
	push @r, htmlMB($s, 'back', $s->cgi->url, ($c->{-backc}||1));
 }
 if	($s->{-logo}) {			# Logotype
	push @r, htmlMB($s, 'logo');
 }
 if	($s->uguest()
	&& $s->{-login}) {		# Login
	push @r,htmlMB($s, 'login', $s->urlAuth());
 }
 if	($g eq 'recList') {		# View menu items
	local @{$s}{-menuchs, -menuchs1} =@{$s}{-menuchs, -menuchs1};
	$s->htmlMChs()	if !$s->{-menuchs};
      # push @r, htmlMB($s, 'recForm');
	push @r, htmlML($s, 'frmName',  $s->{-menuchs})	if $s->{-menuchs};
	push @r, htmlML($s, 'frmLso'
			, ref($om->{-frmLso}) eq 'CODE'
				? &{$om->{-frmLso}}($s, $on, $om, $c, exists($c->{-frmLso}) ? $c->{-frmLso} ||'' : ())
				: $om->{-frmLso})
			if $om->{-frmLso};
	push @r, htmlMB($s,  htmlField($s, '_qftext', lng($s,1,'-qftext'), {-asize=>5, -class=>'MenuButton'}, $s->{-pcmd}->{-qftext}))
							if $s->{-menuchs};
	push @r, htmlML($s, 'frmName1', $s->{-menuchs1})if $s->{-menuchs1};
	push @r, htmlMB($s, 'frmCall',	'')		if $s->{-menuchs};
	push @r, htmlMB($s, 'recXML',	'');
	push @r, htmlMB($s, 'recQBF');
 }
 elsif	($g eq 'recQBF') {		# QBF menu items
	push @r, htmlMB($s, 'recForm',	'');
	push @r, htmlMB($s, 'recList',	'');
 }
 elsif	($g eq 'recDel') {		# Deleted record menu items
 }
 elsif	($s->cgiHook('recOp')) {	# Record menu items
	my $ea =(!$s->{-rac} ||$s->{-pout}->{-editable}) &&!$s->uguest;
	my @rk =('','_form'=>$_[0]->{-pcmd}->{-form}, '_key'=>strdata($_[0], $_[0]->{-pcmd}->{-key}));
	my $ll =$s->lnghash();
	local	$ll->{'recIns'} = $e && $n
				? [$ll->{'recUpd'}->[0], $ll->{'recIns'}->[1]]
				: $ll->{'recIns'};
	local	$IMG->{'recIns'}= $e && $n
				? $IMG->{'recUpd'}
				: $IMG->{'recIns'};
	push @r, htmlMB($s, 'recRead',	[@rk, '_cmd'=>'recRead'])
					if !$n;
	push @r, htmlMB($s, 'recPrint',	[@rk, '_cmd'=>'recPrint'])
					if !$n && !$e;
	push @r, htmlMB($s, 'recXML',	[@rk, '_cmd'=>'recXML','_cmg'=>'recRead'])
					if !$n && !$e;
	push @r, htmlMB($s, 'recEdit',	[@rk, '_cmd'=>'recEdit'])
					if !$n && !$e && $ea;
	push @r, htmlMB($s, 'recForm',	'')	if $e;
	push @r, htmlMB($s, 'recUpd',	'')	if $e && !$n;
	push @r, htmlMB($s, 'recIns',	'')	if $e;
	push @r, htmlMB($s, 'recDel',	'')	if !$n && $ea;
	push @r, htmlMB($s, 'recNew',	undef)	if !$n && $ea;
 }
 if (1) {				# Help button
 }

 my $mi	='[\'<i>'	.htmlEscape($s,lng($s, 0, $c->{-cmd}))
	.'\'@\''	.htmlEscape($s,lng($s, 0, $c->{-cmg}))
	.'\',  '	.htmlEscape($s, $s->user()) .'</i>]';
 my $mh =htmlEscape($s
		, $s->lngcmt($om, $ot)
		|| (($s->{-title} ||$s->cgi->server_name() ||'') .' - ' .($c->{-form} ||'')));
 my $mc =$g ne 'recList'
	? ''
	: join("; "
	, grep {$_
		} 
		  $c->{-qkey}
		? do {	my $ko =$c->{-qkeyord} || ($c->{-qorder} && (substr($c->{-qorder},0,1) eq '-') && $c->{-qorder}) || '-aeq';
			   $ko ={'eq'=>'=','ge'=>'>=','gt'=>'>','le'=>'<=','lt'=>'<'}->{substr($ko,2)}||'=';
			htmlEscape($s
				, join(', ', map { $_ .' ' .$ko .' ' 
						 .(ref($c->{-qkey}->{$_}) 
						  ? '(' .join(',',map {strquot($s,$_)} @{$c->{-qkey}->{$_}}) .')' 
						  : strquot($s,$c->{-qkey}->{$_}))
					} sort keys %{$c->{-qkey}}))
			}
		: ()
		, htmlEscape($s, $c->{-qkeyord}	? lng($s, 0, '-qkeyord')  .' ' .lng($s, 0, $c->{-qkeyord} =~/^-*[db]/ ? 'desc' : 'asc') : '')
		, htmlEscape($s, $c->{-qwhere})
		, htmlEscape($s, $c->{-qurole}	? lng($s, 0, '-qurole')   .' ' .$c->{-qurole} : '')
		, htmlEscape($s, $c->{-quname}	? lng($s, 0, '-quname')   .' ' .$c->{-quname} : '')
		, htmlEscape($s, $c->{-qftext}	? lng($s, 0, '-qftext')   .' ' .$c->{-qftext} : '')
		, htmlEscape($s, $c->{-qversion}? lng($s, 0, '-qversion') .' ' .$c->{-qversion} : '')
		, htmlEscape($s, $c->{-qorder}	? lng($s, 0, '-qorder')	  .' ' .($c->{-qorder} !~/^-/ ? $c->{-qorder} : lng($s, 0, $c->{-qorder} =~/^-[db]/ ? 'desc' : 'asc')) : '')
	);
    $mc = ($g eq 'recList') && ($om->{-frmLso1C} ||($ot->{-frmLso1C} && !exists($om->{-frmLso1C})))
	? &{$om->{-frmLso1C}||$ot->{-frmLso1C}}($s,$on,$om,$c,$c->{-frmLso},$mc)
	: $mc;

 !$s->{-icons}
 ?  "\n<span class=\"MenuArea\">" .join("\n", @r, $mi, '<br />', $mh, '<br />', $mc ? ($mc, '<br />') : ()) ."</span>\n\n"
 : ("\n<table class=\"MenuArea\" cellpadding=0><tr>\n"
	# style=\"position: absolute; top: 0; left: 0;\"
	# <br /><br />
	# scrollHeight
	.join("\n", @r)
	."\n" .'<td class="MenuCell" valign="middle"><nobr>'
	. $mi .'</nobr></td></tr>'
	."\n" .'<tr><th class="MenuHeader" align="left" valign="top" colspan=20>' 
	.$mh .'</th></tr>'
	.(!$mc 	? ''
		: ("\n" .'<tr><td class="MenuComment" align="left" valign="top" colspan=20>' 
			.$mc 
			.'</td></tr>'))
	."\n</table>\n"
	.(!$c->{-refresh} 
	? '<script for="window" event="onload">{var w=window.document.getElementsByTagName(\'table\')[' .($e ? 1 : 0) .']; if(w){w.focus()}}</script>' ."\n" 
	: '')
	.(0
	? '<script for="window" event="onscroll">{var w=window.document.getElementsByTagName(\'table\')[0]; window.status=document.body.scrollTop; if (!w) {} else if(document.body.scrollTop >(w.height||0)){w.style.position="absolute"; w.style.top=document.body.scrollTop} else {w.style.position="static"} return(true)}</script>' ."\n" 
	: '')
	."\n")
}


sub htmlMB {	# CGI menu bar button
		# self, command, url, back|
 my $td0='<td class="MenuButton" valign="middle" style="border-width: thin; border-style: outset; background-color: activeborder;" '; 
							# buttonface
 my $tdb=' onmousedown="if(window.event.button==1){this.style.borderStyle=&quot;inset&quot;}" onmouseup="this.style.borderStyle=&quot;outset&quot;" onmouseout="this.style.borderStyle=&quot;outset&quot;" onmousein="this.style.cursor=&quot;hand&quot"';
  # $tdb='' if ($ENV{HTTP_USER_AGENT}||'') !~/MSIE/;

 if (!$_[0]->{-icons}) {
	if ($_[1] =~/^</) {
		$_[1]
	}
	elsif ($_[1] eq 'logo') {
		ref($_[0]->{-logo}) eq 'CODE' 
		? &{$_[0]->{-logo}}(@_) 
		: $_[0]->{-logo}
	}
	elsif ($_[1] eq 'login') {
		$_[1]
	}
	elsif ($_[1] eq 'back') {
		 '<input type="submit" class="MenuButton" name="_' .$_[1] .'" '
		.' value="' .htmlEscape($_[0],lng($_[0], 0, $_[1])) .'" '
		.' onclick="{'
		.(!$_[3] ||$_[3] <2
			? 'window.history.back()'
			: 'window.history.go(-' .($_[3]-1) .'); window.history.back()')
		.'; return(false)}" '
		.' title="' .htmlEscape($_[0],lng($_[0], 1, $_[1])) .'" />'
	}
	else {
		 '<input type="submit" class="MenuButton" name="_' .$_[1] .'" '
		.' value="' .htmlEscape($_[0],lng($_[0], 0, $_[1])) .'" '
		.' title="' .htmlEscape($_[0],lng($_[0], 1, $_[1])) .'" />'
	}
 }
 elsif ($_[1] =~/^</) {
	$td0 ."><nobr>\n" .$_[1] ."\n</nobr></td>"
 }
 elsif ($_[1] eq 'logo') {
	$td0 ."><nobr>\n" 
	.(ref($_[0]->{-logo}) eq 'CODE' 
		? &{$_[0]->{-logo}}(@_) 
		: $_[0]->{-logo}) ."\n</nobr></td>"
 }
 elsif ($_[1] eq 'login') {
	my $jc =' onclick="{window.location.replace(&quot;'
		.htmlEscape($_[0], $_[2])
		.'&quot;); return(false)}" ';
	my $tl =htmlEscape($_[0], lng($_[0], 1, 'login'));
	$td0  .' title="' .$tl .'"'
	.($tdb ? $tdb .$jc : '') ."><nobr><font size=-1>\n"
	.'<a href="' .$_[2] .'" '
	.' title="' .$tl .'" '
	.' class="MenuButton" style="color: black;" '
	.($tdb ? '' : $jc)
	.' ><img src="' .$_[0]->{-icons} .'/' .$IMG->{'login'} 
	.'" border=0  align="bottom" height="22" class="MenuButton" />'
	.htmlEscape($_[0], lng($_[0], 0, 'login')) ."</a>\n</font></nobr></td>"
 }
 elsif ($_[1] eq 'back') {
	my $jc =' onclick="{'
		.(!$_[3] ||$_[3] <2
			? 'window.history.back()'
			:('window.history.go(-' .($_[3]-1) 
				.'); window.history.back()'))
		.'; return(false)}" ';
	my $tl =htmlEscape($_[0], lng($_[0], 1, 'back', ($_[3]||1)));
	$td0 .' title="' .$tl .'"'
	.($tdb ? $tdb .$jc : '') ."><nobr><font size=-1>\n"
	.'<a href="' .($_[2]||$_[0]->cgi->url) .'" ' 
	.($tdb ? '' : $jc)
	.' title="' .$tl .'"'
	.' class="MenuButton"><img src="' .$_[0]->{-icons} .'/' .$IMG->{'back'} .'" border=0 align="bottom" height="22" class="MenuButton" '
	.' /></a>' ."\n</font></nobr></td>"
 }
 else {
	my $jc =' onclick="{_cmd.value=&quot;' .$_[1] .'&quot;; submit(); return(false)}" ';
	my $tl =htmlEscape($_[0],lng($_[0], 1, $_[1]));
	$td0 .' title="' .$tl .'"'
	.($tdb ? $tdb .$jc : '') ."><nobr>\n"
	.'<input type="image" name="_' .$_[1] .'" '
	.' src="' .$_[0]->{-icons} .'/' .($IMG->{$_[1]}||'none') .'" '
	.' align="bottom" title="' .$tl .'" class="MenuButton" /><font size=-1>'
	.(defined($_[2]) && !$_[2]
	?('<span class="MenuButton" style="color: black; cursor:default; "'
	 .' title="' .$tl .'">' .htmlEscape($_[0],lng($_[0], 0, $_[1])) .'</span>')
	 .($tdb ? '' : $jc)
	:('<a tabindex=-1 href="' .urlCat($_[0], !$_[2] ? ('', '_form'=>$_[0]->{-pcmd}->{-form},'_cmd'=>$_[1]) : ref($_[2]) ? @{$_[2]} : $_[2]) .'"'
	 .' class="MenuButton" style="color: black;"' #{text-decoration:none;color:black}
	 .($tdb ? '' : $jc)
	 .' title="' .$tl .'">'
	 .htmlEscape($_[0],lng($_[0], 0, $_[1]))
	 .'</a>'))
	."\n</font></nobr></td>"
 }
}


sub htmlML {	# CGI menu bar list
 use locale;
 my $i =  $_[1] eq 'frmName'
	? $_[0]->cgi->param('_'  .$_[1]) 
	||$_[0]->{-pcmd}->{'-' .$_[1]}
	||$_[0]->{-pcmd}->{-form} ||''
	: $_[1] eq 'frmLso'
	? $_[0]->{-pcmd}->{'-' .$_[1]} ||''
	: '';
 ($_[0]->{-icons} ? '<td class="MenuButton" valign="middle" title="'
	.$_[0]->htmlEscape(lng($_[0], 1, $_[1]))
	.'" style="border-width: thin; border-style: outset; background-color: buttonface;" >' : '')
 .'<select name="_' .$_[1]
 .'" class="MenuButton" onchange="{'
 .( $_[1] eq 'frmLso'
  ? 'if (_frmLso.value==&quot;recQBF&quot;) {_cmd.value=_frmLso.value; _frmLso.value=&quot;' .$_[0]->htmlEscape($i) .'&quot;; submit(); return(true);} else {_cmd.value=&quot;frmCall&quot;; submit(); return(false);}}">'
  : 1 && ($_[1] eq 'frmName1')
  ? "var v=_frmName1.value; _frmName1.value=''; window.document.open('" .$_[0]->cgi->url() ."?_cmd=frmCall;_frmName1=' +encodeURIComponent(v), '_self', '', false); return(true);}\">" 
  : ('_cmd.value=&quot;frmCall&quot;; '
    .(($_[1] eq 'frmName') && $_[0]->{-menuchs1} ? '_frmName1.value=&quot;&quot;; ' : '')
    .'submit(); return(false);}">'))
 ."\n\t"
 .join("\n\t"
	, map { my ($n, $l) =!ref($_) 
			? ($_, ucfirst($_[0]->lng(0, $_)))
			: ref($_) eq 'ARRAY'
			? ($_->[0]
				, (ref($_->[1]) ? $_[0]->lnglbl($_->[1]) : $_->[1])
				|| ucfirst($_[0]->lng(0, $_->[0])))
			: ($_->{-val}, $_[0]->lnglbl($_) ||ucfirst($_[0]->lng(0, $_->{-val})));
		'<option ' 
			.($i && ($n eq $i) 
			? do{$i =''; 'selected'}
			: '') 
		.(($n eq '') || ($l =~/^[-]+/)
		 ? ' class="MenuButton MenuSeparator"' 
		 : ' class="MenuButton"')
		.' value="' 
		.htmlEscape($_[0], $n)
		.'">' 
		.htmlEscape($_[0], $l)
		.'</option>'
		} @{$_[2]}
	)
 .($i eq ''
  ? ''
  : '<option selected class="MenuButton'
	.(($i eq '') || ($i =~/^[-]+/)
	 ? ' MenuSeparator'
	 : '')
	.'" value="'
	.htmlEscape($_[0], $i) .'">' .htmlEscape($_[0], $_[0]->lng(0, $i))
	.'</option>')
 ."\n</select>"
 .($_[0]->{-icons} ? '</td>' : '')
}


sub htmlMChs {	# Adjust CGI forms list
 if (!$_[0]->{-menuchs}) {
 $_[0]->{-menuchs} =[];
 if	($_[0]->{-form}) {
	push @{$_[0]->{-menuchs}},
		map {[$_, ($_[0]->lnglbl($_[0]->{-form}->{$_},$_)||$_)]
			} grep {$_ ne 'default'} keys %{$_[0]->{-form}}
 }
 if	($_[0]->{-table}) {
	push @{$_[0]->{-menuchs}},
	map {[$_, ($_[0]->lnglbl($_[0]->{-table}->{$_},$_)||$_)]
		} keys %{$_[0]->{-table}}
 }
 @{$_[0]->{-menuchs}} =sort {lc(ref($a) && $a->[1] || $a) cmp lc(ref($b) && $b->[1] || $b)} @{$_[0]->{-menuchs}};
 if ($_[0]->{-menuchs}) {
	my @a =( ['','--- ' .lng($_[0], 0, 'frmCallNew') .' ---']
		, map {[$_->[0] .'+', $_->[1] .' ++']
			} grep { my $m;
				  ($m =$_[0]->{-form}->{$_->[0]})
				?  $m->{-field}
				: ($m =$_[0]->{-table}->{$_->[0]})
				? !$m->{-ixcnd}
				: 0
				} @{$_[0]->{-menuchs}}
		);
	if (@{$_[0]->{-menuchs}} <6)	{push @{$_[0]->{-menuchs}}, @a}
	else				{$_[0]->{-menuchs1} =[@a]}
 }}
 if ($_[0]->{-menuchs1} && $_[0]->{-menuchs1}->[0]->[0]) {
	unshift @{$_[0]->{-menuchs1}}, ['', '--- ' .lng($_[0], 0, 'frmCallNew') .' ---']
 }
 $_[0]->{-menuchs}
}


sub cgiDBData {	# Database data fields/values
		# self, form, meta, value hash
 my ($s, $n, $m, $c, $v) =@_;
     $m =$s->{-form}->{$n}||$s->{-table}->{$n} if !$m;
 my  $mt=$m->{-field}||($m->{-table} && $s->{-table}->{$m->{-table}}->{-field})||[];
 my  $mn=exists($m->{-null}) ? $m->{-null} : $m->{-table} ? $s->{-table}->{$m->{-table}}->{-null} : undef;
 my  $r ={};
 if (($c && $c->{-cmg} ||'') eq 'recNew') {
	$r->{-new} =$s->strtime;
 }
 foreach my $f (@$mt) {
	next if ref($f) ne 'HASH';
	$r->{$f->{-fld}} =!defined($v->{$f->{-fld}})
			? $v->{$f->{-fld}}
			: exists($f->{-null})
			? (defined($f->{-null}) && ($v->{$f->{-fld}} eq $f->{-null})
				?  undef : $v->{$f->{-fld}})
			: defined($mn)
			? ($v->{$f->{-fld}} eq $mn ? undef : $v->{$f->{-fld}})
			: $v->{$f->{-fld}}
		if exists ($v->{$f->{-fld}})
		&& (!$f->{-flg}
		||   $f->{-flg} =~/[au]/);	# 'a'll, 'u'pdate
 }
 %$r ? $r : undef
}


sub cgiForm {	# Print CGI screen form
		# self, form name, form meta, command, data
 my ($s, $n, $m, $c, $d) =@_;
    $m =$s->{-form}->{$n}||$s->mdeTable($n) if !$m;
    $c =$s->{-pcmd} if !$c;
    $d =$s->{-pout} if !$d;

 return($s) if $c->{-cmg} eq 'recDel';

 my $qm=$c->{-cmg} eq 'recQBF';
    $d =ref($m->{-query}->{-qkey}) eq 'CODE'
	? &{$m->{-query}->{-qkey}}($s, $n, $m, $c)
	: {%{$m->{-query}->{-qkey}}}	if $qm && (!$d ||!%$d) && $m->{-query}
					&& $m->{-query}->{-qkey};
 my $em=$c->{-edit} || $qm;
 my $mt=$m->{-table} ? $s->mdeTable($m->{-table}) : $m;
 my ($lt, $lr) =$c->{-xml} ? (1,1) : (0,1);

 $s->output('<table>'
	,"\n<tr>\n"
	, $m->{-fwidth}		# !!! not documented, not needed ???
	? '<th colspan=20><nobr>' 
		.('&nbsp;' x $m->{-fwidth}) ."</nobr></th></tr>\n<tr>\n"
	: ''
	) if !$c->{-xml};
 # form additions	- using sub{} fields
 # file attachments	- using 'tfdRFD' / 'htmlRFD'
 # versions		- using sub{} fields with queries
 # embedded views	- using sub{} fields with queries
 foreach my $v (@{$m->{-field} 
		||($m->{-query} && $m->{-query}->{-data})
		||($m->{-table} && $s->mdeTable($m->{-table})->{-field})
		}) {
	my $f =(ref($v) && $v) || ($mt->{-mdefld} && $mt->{-mdefld}->{$v}) || $v;
	if	($c->{-xml} 
		&& !ref($f))	{
		next
	}
	elsif	($c->{-xml})	{
		if	(ref($f) eq 'CODE')		{next}
		elsif	($f->{-inp}
			&& $f->{-inp}->{-rfd}
			&& $s->{-pout}->{-file})	{
			my $u =$s->rfdPath(-url=>$s->{-pcmd}, $s->{-pout});
			   $u =$s->cgi->url(-base=>1) .$u if $u !~/\/\/\w+:/;
			my $v =join("\n", map { $u .'/' .$_
				} $s->rfdGlobn($s->{-pcmd}, $s->{-pout}));
			$s->output($s->xmlsTag('files',''=>$v),"\n");
			next
		}
		elsif	(!$f->{-fld}
			||!defined($d->{$f->{-fld}})
			||($d->{$f->{-fld}} eq ''))	{next}
		my $v =$d->{$f->{-fld}};
		if	($f->{-inp} && $f->{-inp}->{-htmlopt}
			&& $s-ishtml($v))	{
			$s->output('<',$f->{-fld},'>',$v,'</',$f->{-fld},">\n")
		}
		elsif	($f->{-inp} && $f->{-inp}->{-hrefs}) {
			# !!! no -cgibus special urls
			my $u =$s->rfdPath(-url=>$s->{-pcmd}, $s->{-pdta})||$s->rfdPath(-urf=>$s->{-pcmd}, $s->{-pdta});
			   $u =$s->cgi->url(-base=>1) .$u if $u !~/\/\/\w+:/;
			$v =~s/\b((?:host|urlh):\/\/)/$s->cgi->url(-base=>1) .'\/'/ge;
			$v =~s/\b((?:url|urlr):\/\/)/$s->cgi->url() .'\/'/ge;
			$v =~s/\b((?:fsurl|urlf):\/\/)/$u .'\/'/ge;
			$s->output($s->xmlsTag($f->{-fld}, ''=>$v), "\n")
		}
		else	{
			$s->output($s->xmlsTag($f->{-fld}, ''=>$v), "\n")
		}
		next
	}
	elsif	($f eq '')	{			# next col
		$lr =0;
		next
	}
	elsif	($f =~/^(\n*)(\t*)$/)	{
		$lr =0;
		if	($1)		{		# new lines
			$s->output((!$lt ? "\n</tr>\n<tr>\n" : "\n<br />\n") 
					x (length($1)/length("\n")));
			$lr =1;
		}
		if	($2)		{		# skip cells
			$s->output($lr ? "\n</tr>\n<tr>\n" : ''
				, "<td> </td>\n" x length($2))
				if !$lt;
			$lr =0;
		}
		next;
	}
	elsif	($f eq "\f")		{		# close table
		$s->output("\n</tr>\n</table>\n");
		$lt =1; $lr =1;
		next 
	}
	elsif	($f eq '</table>')		{	# close table & labels
		$s->output("\n</tr>\n</table>\n");
		$lt =2; $lr =1;
		next 
	}
	elsif	(!$f)			{next}
	elsif	(!ref($f))		{$s->output($f); next}
	elsif	(ref($f) eq 'CODE')	{$s->output(&$f($s,$n,$m,$c,$d)); next}
	else				{}

	local  $_=$d->{$f->{-fld}};
	my $excl =0;
	my $hide = $qm && ($f->{-flg}||'') =~/[aq]/	# 'a'll, 'q'uery
		 ? 0
		 : ((ref($f->{-hide})  eq 'CODE' ? &{$f->{-hide}} ($s,$f,$em,$qm,$_)  : $f->{-hide})
		 || (ref($f->{-hidel}) eq 'CODE' ? &{$f->{-hidel}}($s,$f,$em,$qm,$_) : $f->{-hidel})
		 || ($qm && !$f->{-fld})
		 || ($qm && ($f->{-flg}||'q') !~/[aq]/)
		 || ($qm && $f->{-inp} && ((ref($f->{-inp}) ne 'HASH') || grep {$f->{-inp}->{$_}} qw(-rows -arows -hrefs -rfd))));
	my $edit =!$em
		? $qm
		: ref($f->{-edit})  eq 'CODE'
		? $qm ||&{$f->{-edit}}(@_)
		: exists($f->{-edit})
		? $qm ||$f->{-edit}
		: $f->{-flg}		# 'a'll, 'e'dit', 'q'uery
		? $f->{-flg}=~/[ae]/ ||($qm && $f->{-flg}=~/[q]/)
		: 1;

	my $fuc =!$excl && !$hide && $f->{-fld} && $s->mdeFldIU($mt, $f->{-fld});
	my $lbl =$s->htmlEscape($s->lnglbl($f,'-fld'));
	my $cmt =($s->lngcmt($f) ||$s->lng(1, $f->{-fld})) .' [' .$f->{-fld} .($f->{-flg} ? ': ' .$f->{-flg} : '') .']';
	my $rid =$hide	|| $excl
		? undef
		: $edit && !$c->{-print}
		  && $f->{-ddlb} && !ref($f->{-ddlb}) && ($f->{-ddlb} !~/\s/)
		  && (!defined($d->{$f->{-fld}}) || ($d->{$f->{-fld}} eq ''))
		? '<a href="?_cmd=recList'
			.$HS .'_form=' .$s->htmlEscape($f->{-ddlb})
			.'">'
		: (!defined($d->{$f->{-fld}}) || ($d->{$f->{-fld}} eq ''))
		? undef
		: !$c->{-print} 
		  && (	   $f->{-form} 
			|| (($f->{-flg}||'')=~/[h]/)
			|| $fuc
			|| (		($f->{-ddlb} 
					&& (!$f->{-ddlbtgt}
					   ? 1
					   : !ref($f->{-ddlbtgt})
					   ? ($f->{-ddlbtgt} !~/^<+/) 
						|| ($d->{$f->{-fld}} !~/[,;]/)
					   : !ref($f->{-ddlbtgt}->[0])
					   ? !$f->{-ddlbtgt}->[0]
						|| ($f->{-ddlbtgt}->[0] !~/^<+/)
						|| ($d->{$f->{-fld}} !~/[,;]/)
					   : !$f->{-ddlbtgt}->[0]->[2] 
						|| ( $f->{-ddlbtgt}->[0]->[2] =~/\d/ 
						   ? $d->{$f->{-fld}} !~/[,;]/
						   : index($d->{$f->{-fld}}, $f->{-ddlbtgt}->[0]->[2]) <0)
						)
					|| $f->{-inp} 
					&& ($f->{-inp}->{-values} 
						||$f->{-inp}->{-labels}))
				&& (($f->{-flg}||'')=~/[aiuq]/)))
		? '<a href="?'
			.($f->{-form} ? '' : '_cmd=recList' .$HS)
			.'_form=' .$s->htmlEscape(
					   $f->{-form} && ($f->{-form} !~/^[\dy]$/i) 
					&& $f->{-form}
					|| $m->{-table} ||$n)
			.$HS .'_key='  .$s->htmlEscape($s->strdatah($f->{-fld} => $d->{$f->{-fld}}))
			.'">'
		: $qm
		? undef
		: (($m->{-ridRef} ||$s->{-ridRef})
			&& (grep {$f->{-fld} eq $_} @{$m->{-ridRef}||$s->{-ridRef}})
			|| ($f->{-fld} eq ($m->{-rvcActPtr}||$s->{-rvcActPtr}||'"'))
			|| ($f->{-fld} eq ($m->{-key} && @{$m->{-key}} <2 && $m->{-key}->[0]))
			)
		  && (!$f->{-inp} || !(grep {$f->{-inp}->{$_}} qw(-arows -rows -cols -hrefs -htmlopt)))
		? '<a href="?_cmd=recRead' 
		  .( $d->{$f->{-fld}} !~/\Q$RISM1\E/ 
		   ? $HS .'_form=' .$s->htmlEscape($n) 
		   : '')
		  .$HS .'_key=' .$s->htmlEscape($d->{$f->{-fld}}) .'">'
		: undef;
	if	($excl||$hide)	{$lbl =' '}
	elsif	(defined($f->{-lblhtml})) {
		my $l =$f->{-lblhtml};
		$l =&$l($s,$f,$em,$qm,$_) if ref($l) eq 'CODE';
		$l =~s/<\s*input[^<>]*>//ig if !$em;
		$l =~s/\$_/$lbl/;
		$lbl =$l
	}
	$lbl	=$rid .$lbl .'</a>'
		if $rid && $em && $edit && $lbl !~/<a\s+href\s*=\s*/i;
	$lbl	=$hide && $f->{-hidel}
		? $lbl
		: $lt >1 && (!$f->{-inp} || !$f->{-inp}->{-rfd})
		? ''
		: $lt
		? '<span' 
			.($f->{-fhclass} ? ' class="' .$f->{-fhclass} .'"' : '')
			.($f->{-fhstyle} ? ' style="' .$f->{-fhstyle} .'"' : '')
			.' title="' .htmlEscape($s,$cmt) .'"'
			.($f->{-fhprop} ? ' ' .$f->{-fhprop} : '')
			.'>' .$lbl .'</span>'
		: $lbl =~/<t[dh]\b/i 
		? $lbl 
		:('<th align="left" valign="top"'
			.($f->{-fhclass} ? ' class="' .$f->{-fhclass} .'"' : '')
			.($f->{-fhstyle} ? ' style="' .$f->{-fhstyle} .'"' : '')
			.' title="' .htmlEscape($s,$cmt) .'"'
			.($f->{-fhprop} ? ' ' .$f->{-fhprop} : '')
			.'>' .$lbl .'</th>');

	my $wgp =$excl || $hide
		? ''
		: $edit
		? htmlField($s, $f->{-fld}, $cmt, $f->{-inp}, $d->{$f->{-fld}})
		: $f->{-inp} && ($f->{-inp}->{-labels} || $f->{-inp}->{-hrefs} || $f->{-inp}->{-htmlopt})
		? htmlField($s, '', $cmt, $f->{-inp}, $d->{$f->{-fld}})
		: $fuc || $s->mdeFldRW($mt, $f->{-fld})
		? $s->udisp($d->{$f->{-fld}})
		: htmlField($s, '', $cmt, $f->{-inp}, $d->{$f->{-fld}});
	if (!$hide && defined($f->{-inphtml})) {
		my $wgh	=$f->{-inphtml};
		$wgh	=&$wgh($s,$f,$em,$qm,$_) if ref($wgh) eq 'CODE';
		$wgh	=~s/<\s*input[^<>]*>//ig if !$edit;
		$wgh	=~s/\$_/$wgp/;
		$wgp	=$wgh
	}
	$wgp	=$rid .$wgp .'</a>'
		if $rid && !$edit && $wgp !~/<a\s+href\s*=\s*/i;
	$wgp	='<td valign="top" align="left"'
		.($f->{-colspan} ? ' colspan=' .$f->{-colspan} :'')
		.($f->{-fdclass} ? ' class="'  .$f->{-fdclass} .'"' : '')
		.($f->{-fdstyle} ? ' style="'  .$f->{-fdstyle} .'"' : '')
		.($f->{-fdprop}	 ? ' ' .$f->{-fdprop} : '')
		.'>' .$wgp .'</td>'
		if $wgp !~/<t[dh]\b/i && !$lt 
		&& !($hide && $f->{-hidel});

	if	(!$lt) {
		if ($f->{-ddlb} && $em) {
			my $wg1;
			($wgp, $wg1) =($1, $2) if $wgp =~/^(.*)(<\/t[dh]>)$/i;
			$s->output((!$lr ? '' : "\n</tr>\n<tr>\n"), $lbl, $wgp);
			$s->cgiDDLB($f, $m);
			$s->output($wg1, "\n");
			$wgp .=$wg1
                }
		else {
			$s->output((!$lr ? '' : "\n</tr>\n<tr>\n"), $lbl, $wgp, "\n");
		}
	}
	elsif	(!$hide) {
		if ($f->{-ddlb} && $em) {
			$s->output($lbl, ' ', $wgp);
			$s->cgiDDLB($f, $m);
			$s->output("<br />\n")
		}
		elsif ($wgp ne '')  {
			$s->output($lbl, ' ', $wgp
				, $wgp =~/<(\/p|br\s*\/)>[\s\r\n]*$/i
				? "\n" : "<br />\n")
		}
	}
	$lr =1
 }

 if ($qm) {	# Query condition fields
	my $q =$m->{-query} ||{};
	$s->output("<table>\n") if $lt;
	$lt =0; $lr =1;
	my $th =sub{'<tr><th align="left" valign="top" title="' 
			.htmlEscape($_[0], lng($_[0], 1 ,$_[1]))
			.'">'
			.htmlEscape($_[0], lng($_[0], 0, $_[1]))
			.'</th>'
			};
	my $td ='<td align="left" valign="top" colspan=10>';
	my $de =$s->{-table}->{$m->{-table}||$n};
	   $de =($de && $de->{-dbd})||$s->{-tn}->{-dbd};
	my $qo ={qw (all all eq == ge >= gt > le <= lt <)};
	   $qo ={map {("-a$_", 'asc ' .$qo->{$_}, "-d$_", 'dsc ' .$qo->{$_})} keys %$qo};
	my $qk =1; # -qkeyord switch
	$s->{-pcmd}->{-qkey} =$s->cgiQKey($n,$m,$s->{-pdta});
	$s->output(&$th($s, '-qkeyord'), $td
		, htmlField($s, '_qkeyord', lng($s,1,'-qkeyord')
			, {-labels=>$qo}
			, $s->{-pcmd}->{-qkeyord}||'')
		, '<font size="-1" title="default">'
		, $q->{-keyord} || ($de eq 'dbm')
		? htmlEscape($s, '(' .($q->{-keyord} && $qo->{$q->{-keyord}} ||$q->{-keyord} ||($de eq 'dbm' ? $qo->{$KSORD} ||$KSORD : '') ||'') .')')
		: ()
		, '</font>'
		, "</td></tr>\n")
		if $qk;
	$s->output(&$th($s, '-qwhere'), $td
		, htmlField($s, '_qwhere', lng($s,1,'-qwhere') .': '
			. ($de eq 'dbm'	? "Perl: {fieldname} (eq|[gl][et]) 'value' and|or {fieldname} <>==value..." 
					: "SQL: fieldname <>= 'value' and|or...")
			, {-arows=>1,-cols=>45}
			, $s->{-pcmd}->{-qwhere} 
			||($q &&( ref($q->{-qwhere}) eq 'CODE'
				? &{$q->{-qwhere}}($s, $n, $m, $c)
				: $q->{-qwhere})))
		, '<font size="-1" title="additional">'
		, !$q->{-where}
		? ()
		: ref($q->{-where}) eq 'ARRAY' 
		? htmlEscape($s, ' AND ' .join(' AND ', @{$q->{-where}}))
		: ref($q->{-where})
		? htmlEscape($s, '(' .$q->{-where} .')')
		: htmlEscape($s, ' AND ' .$q->{-where})
		, $q->{-filter}
		? htmlEscape($s, ' FILTER ' .$q->{-filter})
		: ()
		, $m && $m->{-qfilter}
		? htmlEscape($s, ' FILTER ' .$m->{-qfilter})
		: ()
		, "</font></td></tr>\n");
	if ($s->mdeRAC($m)) {
		$s->output(&$th($s, '-qurole'), $td
		, htmlField($s, '_qurole', lng($s,1,'-qurole'), {-values=>[$s->mdeRoles(0)]}, $s->{-pcmd}->{-qurole})
		, $q->{-urole} 
		? '<font size="-1" title="default">' .htmlEscape($s, '(' .$q->{-urole} .')') .'</font>' 
		: ()
		, htmlField($s, '_quname', lng($s,1,'-quname'), undef, $s->{-pcmd}->{-quname})
		, $q->{-uname} 
		? '<font size="-1" title="default">' .htmlEscape($s, '(' .$q->{-uname} .')') .'</font>'
		: ()
		);
		$s->cgiDDLB({-fld=>'_quname', -ddlb=>sub{$_[0]->uglist({})}});
		$s->output("</td></tr>\n");
	}
	$s->output(&$th($s, '-qftext'), $td
		, htmlField($s, '_qftext', lng($s,1,'-qftext'), {-size=>50}, $s->{-pcmd}->{-qftext})
		, $q->{-ftext} 
		? '<font size="-1" title="default">' .htmlEscape($s, '(' .$q->{-ftext} .')') .'</font>'
		: ()
		, "</td></tr>\n");
	$s->output(&$th($s, '-qversion'), $td
		, htmlField($s, '_qversion', lng($s,1,'-qversion'), {-values=>['-','+']}, $s->{-pcmd}->{-qversion})
		, '<font size="-1" title="default">('
		, $q->{-version} || '-', ')</font>'
		, "</td></tr>\n");
	$s->output(&$th($s, '-qorder'), $td
		, htmlField($s, '_qorder', lng($s,1,'-qorder')
			, {$de eq 'dbm' 
			  ? (-labels=>$qo)
			  :(-asize=>50)}
			, $s->{-pcmd}->{-qorder}||'')
		, '<font size="-1" title="default">'
		, $q->{-order} 
		? htmlEscape($s, '(' .($qo->{$q->{-order}} ||$q->{-order} ||$qo->{$q->{-keyord}} ||$q->{-keyord}) .')')
		: $de eq 'dbm'
		? htmlEscape($s, '(' .($qo->{$KSORD}||$KSORD) .')')
		: ()
		, '</font>'
		, "</td></tr>\n")
		if !$qk;
	$s->output(&$th($s, '-qorder'), $td
		, htmlField($s, '_qorder', lng($s,1,'-qorder')
			, {-asize=>50}
			, $s->{-pcmd}->{-qorder}||'')
		, '<font size="-1" title="default">'
		, $q->{-order} 
		? htmlEscape($s, '(' .($qo->{$q->{-order}} ||$q->{-order}) .')')
		: ()
		, '</font>'
		, "</td></tr>\n")
		if $qk && ($de eq 'dbi');
	$s->output(&$th($s, '-qlimit'), $td
		, htmlField($s, '_qlimit', lng($s,1,'-qlimit')
			, {-values=>[128,256,512,1024,2048,4096]}
			, $s->{-pcmd}->{-qlimit}||'')
		, '<font size="-1" title="default">('
		, $q->{-limit}||$m->{-limit}||$s->{-limit}||$LIMRS
		, ')</font>'
		, "</td></tr>\n");
	$s->output(&$th($s, '-style'), $td
		, htmlField($s, '_style', lng($s,1,'-style'), {-size=>50}, ($s->{-pcmd}->{-style}||'') =~/\x00/ ? $s->{-pcmd}->{-style} =$' : $s->{-pcmd}->{-style})
		, htmlField($s, '_xml', lng($s,1,'-xml'), {-labels=>{''=>'','yes'=>'xml'}})
		, "</td></tr>\n"
		) if 0;
	$s->output('<th></th>', $td
		, htmlEscape($s, $s->urlCat($s->cgi->url(-relative=>1)
			, '_cmd'=>'recList', '_form'=>$s->{-pcmd}->{-form}
			, map { !defined($s->{-pcmd}->{"-$_"}) ||($s->{-pcmd}->{"-$_"} eq '')
				? ()
				: ("_$_"
				  , ref($s->{-pcmd}->{"-$_"}) 
				  ? $s->strdata($s->{-pcmd}->{"-$_"}) 
				  : $s->{-pcmd}->{"-$_"})
			} qw(qkey qkeyord qwhere qurole quname qftext qversion qorder qlimit style xml)
		  ))
		, "</td></tr>\n");
 }
 else {		# Read/Edit, should be nothing

 }

 $s->output(!$lt ? "</table>\n" : "\n") if !$c->{-xml};

 $s
}


sub htmlField {	# Generate field widget HTML
		# self, field name, title, meta, value
 my ($s, $n, $t, $m, $v) =@_;
 my $wgp ='';
 $v ='' if !defined($v);
 if	(!$n)	{				# View only
	if	(ref($m) ne 'HASH')	{			# Textfield
		$wgp  =htmlEscape($s, $v) 
	}
	elsif	($m->{-htmlopt} && $s->ishtml($v))	{	# HTML Text
		$wgp  =$v
	}
	elsif	($m->{-hrefs})	{				# Text & Hyperlinks
		$wgp .='<code>' if $v =~/ {2,}/;
		while ($v =~/\b([\w-]{3,7}:\/\/[^\s\t,()<>\[\]"']+[^\s\t.,;()<>\[\]"'])/) {
			# !!! no -cgibus special urls
			my $r =$1;
			$v    =$';
			my $w =htmlEscape($s, $`); $w =~s/( {2,})/'&nbsp;' x length($1)/ge; $w =~s/\n/<br \/>\n/g; $w =~s/\r//g;
			$wgp .=$w;
			$r    =~s/^(host|urlh):\/\//\//;
			$r    =~s/^(url|urlr):\/\///;
			$r    =~s/^(fsurl|urlf):\/\//($s->rfdPath(-url=>$s->{-pcmd}, $s->{-pdta})||$s->rfdPath(-urf=>$s->{-pcmd}, $s->{-pdta})) .'\/'/e;
			$wgp .="<a href=\"$r\" target =\"_blank\">" .$s->htmlEscape(length($r) >49 ? substr($r,0,47) .'...' : $r) .'</a>';
		}
		$v =htmlEscape($s, $v); $v =~s/( {2,})/'&nbsp;' x length($1)/ge; $v =~s/\n/<br \/>\n/g; $v =~s/\r//g;
		$wgp .=$v;
		$wgp .='</code>' if $wgp =~/^<code>/;
	}
	elsif	(grep {exists($m->{$_})} qw(-arows -rows -cols)) {# Resizeable text
		$v =htmlEscape($s,$v); $v =~s/( {2,})/'&nbsp;' x length($1)/ge; $v =~s/\n/<br \/>\n/g; $v =~s/\r//g;
		$v ="<code>$v</code>" if $v =~/&nbsp;&nbsp/;
		$wgp  =$v;
	}
	elsif	($m->{-values} ||$m->{-labels}) {		# Listbox
		my $l =lngslot($s, $m, '-labels') 
			|| (ref($m->{-values}) eq 'HASH') && $m->{-values};
		$l    =&{$l}($s)	if ref($l) eq 'CODE';
		$v    =$l->{$v}		if $l && defined($l->{$v});
		$wgp  =htmlEscape($s, $v)
	}
	elsif	($m->{-rfd}) {					# RFD Filebox
		$wgp =$s->htmlRFD()
	}
	else {							# Textfield
		$wgp =htmlEscape($s, $v)
	}
 }
 elsif	(!$m) {					# Default text field
	my $l =defined($v) ? length($v) : 0;
	   $l =$l <20 ? 20 : $l >80 ? 80 : $l;
	$wgp  ='<input type="text" name="' .$n
		.'" title="'	.htmlEscape($s, $t)
		.'" size="'	.$l
		.'" value="'	.htmlEscape($s, $v)
		.'" />'
 }
 elsif (ref($m) eq 'HASH') {
	if	(exists $m->{-arows} 
		|| grep {$m->{$_}} qw(-rows -cols -hrefs)) {	# Textarea
		my $a ={%$m}; delete @$a{-hrefs, -arows};
		if (exists($m->{-arows})) {
			my $ar =0;
			$a->{-cols} =20 if !$a->{-cols};
			if ($a->{-wrap} && lc($a->{-wrap}) eq 'off') {
				my @a =split /\n/, $v;
				$ar =scalar(@a)
			}
			else {
				foreach my $r (split /\n/, $v) {
					$ar +=1 +(length($r) >$a->{-cols} 
					? int(length($r)/$a->{-cols}) +1 
					:0);
				}
			}
			$a->{-rows} =($m->{-arows} >$ar ? $m->{-arows} : $ar);
			$a->{-rows} =20 if $a->{-rows} >30;
		}
		if (defined($m->{-hrefs})) {
			my $w =$v;
			my @h;
			while ($w =~/\b([\w-]{3,7}:\/\/[^\s\t,()<>\[\]"']+[^\s\t.,;()<>\[\]"'])/) {
				# !!! no -cgibus special urls
				my $t =$1;
				$w =$';
				$t =~s/^(host|urlh):\/\//\//;
				$t =~s/^(url|urlr):\/\///;
				$t =~s/^(fsurl|urlf):\/\//($s->rfdPath(-url=>$s->{-pcmd}, $s->{-pdta})||$s->rfdPath(-urf=>$s->{-pcmd}, $s->{-pdta})) .'\/'/e;
				push @h, $t;
			}
			$wgp .=join(';&nbsp; '
				, map {$_ =htmlEscape($s, $_);
					"<a href=\"$_\">"
					.(length($_) >49 ? substr($_,0,47) .'...' : $_)
                                        .'</a>'} @h);
			$wgp .='<br />' if $wgp;
		}
		$wgp .=$s->cgi->textarea(
			(map {($_ =>	(ref($a->{$_}) eq 'CODE' 
					? &{$a->{$_}}($s,$a,local($_)=$v)
					: $a->{$_}))} keys %$a)
			,-name=>$n, -title=>$t, -default=>$v);
		$wgp .="<input type=\"submit\" name=\"${n}__b\" value=\"R\" "
		."title=\"Rich/Text edit: ^Bold, ^Italic, ^Underline, ^hyperlinK, Enter/shift-Enter, ^(shift)T ident, ^Z undo, ^Y redo.\" "
		."style=\"font-style: italic;\" "
			# ; font-weight: bold; font-family: fantasy
		."onclick=\"{if(${n}__b.value=='R') {${n}__b.value='T'; $n.style.display='none'; "
		."\n var r; r =document.createElement('<span contenteditable=true id=&quot;${n}__r&quot; title=&quot;MSHTML Editing Component&quot; ondeactivate=&quot;{$n.value=${n}__r.innerHTML}&quot;></span>'); ${n}__b.parentNode.insertBefore(r, $n)\n"
		# ${n}__b.parentNode.appendChild(r);
		# r.execCommand('Font', 1)
		."r.contentEditable='true'; r.style.borderStyle='inset'; r.style.borderWidth='thin'; r.normalize; r.innerHTML =!$n.value ? ' ' : $n.value; r.focus();}\n"
		."else {${n}__b.value='R'; $n.value=!${n}__r.innerHTML ? '' : ${n}__r.innerHTML.substr(0,1)!='&lt;' && ${n}__r.innerHTML.indexOf('&lt;')>=0 ? '&lt;span&gt;&lt;/span&gt;' +${n}__r.innerHTML : ${n}__r.innerHTML; ${n}__r.removeNode(true); $n.style.display='inline'; $n.focus();};\n"
				#${n}__r.innerHTML ? ${n}__r.innerHTML : ''; ${n}__r.removeNode(true); $n.style.display='inline'; $n.focus();};\n"
		." return(false)}\" />\n"
		#MSHTML Edit Control for IE5.5
		if $m->{-htmlopt} && ($ENV{HTTP_USER_AGENT}||'') =~/MSIE/;
	}
	elsif	(exists $m->{-asize}) {			# Textfield
		$wgp  =$s->cgi->textfield(
			(map {	  $_ ne '-asize'
				? ($_=>ref($m->{$_}) ne 'CODE' 
					? $m->{$_} 
					: &{$m->{$_}}($s,$m,local($_)=$v))
				: ('-size'=>do {
					my $z =$m->{-asize};
					   $z =(ref($z) ne 'CODE' 
						? $z 
						: &$z($s,$m,local($_)=$v)) ||20;
					my $l =defined($v) ? length($v) : 0;
					$l < $z ? $z : $l >80 ? 80 : $l;
					})
				} keys %$m)
			,-name=>$n
			,-title=>$t
			,-override=>1
			,-default=>$v)
	}
	elsif	($m->{-values} ||$m->{-labels}) {	# Listbox
		my $tv	=$m->{-values};
		   $tv	=&$tv($s) if ref($tv) eq 'CODE';
		my $tl	=$s->lngslot($m, '-labels');
		   $tl	=&$tl($s) if ref($tl) eq 'CODE';
		$tv	=do{use locale; [sort {$tl->{$a} cmp $tl->{$b}} keys %$tl]}
			if !$tv && $tl;
		$v	=$s->strdata($v)
			if ref($v);
		unshift @$tv, $v if defined($v) && ($v ne '') && !grep {$_ eq $v} @$tv;
		unshift @$tv, '' if $s->{-pcmd}->{-cmg} eq 'recQBF';
		$wgp	=$s->cgi->popup_menu(
			(map {($_ =>	(ref($m->{$_}) eq 'CODE'
					? &{$m->{$_}}($s,$m,local($_)=$v)
					: $m->{$_}))} keys %$m)
			,-name=>$n, -title=>$t
			, $tv ? (-values=>$tv) : ()
			, $tl ? (-labels=>$tl) : ()
			,-override=>1,-default=>$v)
	}
	elsif	($m->{-rfd}) {				# RFD Filebox
		$wgp =$s->htmlRFD()
	}
	else {						# Textfield
		$wgp =$s->cgi->textfield(
			(map {($_ =>	(ref($m->{$_}) eq 'CODE' 
					? &{$m->{$_}}($s,$m,local($_)=$v)
					: $m->{$_}))} keys %$m)
			,-name=>$n,-title=>$t,-override=>1,-default=>$v)
	}
 }
 elsif (ref($m) eq 'CODE') {			# Any other...
	$wgp =&$m(@_)
 }
 $wgp
}


sub htmlRFD {	# RFD widget html
 my ($s, $n, $m, $c, $d) =@_;
     $n =$s->{-pcmd}->{-form} if !$n || $n=~/^\d*$/;
     $m =$s->{-form}->{$n}||$s->{-table}->{$n} if !$m;
     $c =$s->{-pcmd} if !$c;
     $d =$s->{-pout} if !$d;
 return('') if !$d->{-file};
 my  $edt=$s->{-pcmd}->{-edit} && $d->{-file} && $d->{-fupd};
 my  $pth=$s->rfdPath(-path=>$c, $d);
 my  $urf=$s->rfdPath(-urf=>$c, $d);
 my  $url=$s->rfdPath(-url=>$c, $d);
 my  $fnu='_file_u';
 my  $fnc='_file_c';
 my  $fnf='_file_f';
 my  $fnl='_file_l';
 my  $fno='_file_o';
 my  $r ='';
 if ($edt && $s->cgi->param($fnu)) {	# Upload
	$s->rfaUpload($c, $d, $fnu);
 }
 if ($edt && $urf 			# Close
 &&  $s->cgi->param($fnc)) {
	$s->nfclose($pth, [$s->cgi->param($fnc)])
 }
 if ($edt && $s->cgi->param($fnf)) {	# Delete
	$s->rfaRm($c, $d, [$s->cgi->param($fnl)])
 }

 if ($edt) {				# Edit widget
	my $fo =($s->cgi->param($fno)||$s->cgi->param($fnc))
		&& $s->nfopens($pth,{});
	$r .=$s->cgi->filefield(-name=>$fnu, -title=>$s->htmlEscape($s->lng(1,'rfauplfld')))
	.$s->cgi->submit(-name=>$fnf, -value=>$s->lng(0,'rfaupdate'), -title=>$s->lng(1,'rfaupdate'))
	.(!$fo && $^O eq 'MSWin32'
		? $s->cgi->submit(-name=>$fno, -value=>$s->lng(0,'rfaopen'), -title=>$s->lng(1,'rfaopen'))
		: '')
	.($fo	? $s->cgi->scrolling_list(-name=>$fnc, -override=>1, -multiple=>'true'
			, -title=>$s->lng(1,'rfaopen')
			, -values=>	['--- ' .$s->lng(0,'rfaclose') .' ---'
					,ref($fo) eq 'HASH' ? sort keys %$fo : @$fo]
			, ref($fo) eq 'HASH' ? (-labels=>$fo) : ())
		: '');
	if ($urf && $urf =~/^file:(.*)/i) {
		my $fs =$1; $fs =~s/\//\\/g;
		$r .="\n<font size=-1>[ <span "
		# .' onclick="window.event.srcElement.select" '
		# .' oncopy="{window.clipboardData.setData(\'Text\',\'' .$s->htmlEscape($fs) .'\'); return(false)}" '
		# window.event.srcElement
		# document.selection.empty(); 
		.' title="' .$s->htmlEscape($s->lng(1,'rfafolder') .' ') .'" '
		.'><a href="' .$s->htmlEscape($urf) .'" target="_blank" >'
		.$s->htmlEscape($fs) ."</a></span> ]</font><br />\n";
	}
	else {
		$r .="\n&nbsp;&nbsp;&nbsp;\n"
	}
	$r .=join('; ', 
		map {	my $f =$s->urlEscape($_);
			$s->cgi->a({-href=>"$url/$f", -target=>'_blank'}
			, $s->cgi->checkbox(-name=>$fnl, -value=>$_, -label=>$_, -title=>$s->lng(1,'rfadelm')))
		} $s->rfdGlobn($c, $d))
 }
 else	{				# View widget
	$r .=' '
	.join('; ', 
		map {	my $f =$s->urlEscape($_);
			'<a href="' . "$url/$f" .'" target="_blank" >'
			. $_ .'</a>'
		} $s->rfdGlobn($c, $d))
 }
 $r
}


sub cgiDDLB {	# CGI Drop-down list box
 my ($s, $f) =@_;
 my $d =$f->{-ddlb};
    $d =ref($d) eq 'CODE' ? &$d(@_) : $d;
 my $mv=$f->{-ddlbmult};
 my $tg=$f->{-ddlbtgt} ||$f->{-fld};
 my $ml=!ref($tg) 
	? defined($tg) && $tg =~/[+,;]/
	: !ref($tg->[0])
	? defined($tg->[0]) && $tg->[0] =~/[+,;]/
	: $tg->[0]->[2];
 my $nf=$f->{-fld};
 my $nl=$nf .'__L';	# List
 my $no=$nf .'__O';	# Open	button
 my $nc=$nf .'__C';	# Close	button
 my $ne=$nf .'__S';	# Set	button

 if	($s->{-pdta}->{$ne}) {		# real assignment in 'cgiParse'
	$s->{-pout}->{$tg} =$s->{-pdta}->{$nl};
 }
 if	($s->{-pdta}->{$ne} ||$s->{-pcmd}->{$ne} ||$s->{-pdta}->{$nc}) {
	$s->output('<script for="window" event="onload">{'
	.'window.document.forms[0].' .$nf .'.focus();}</script>');
 }
 if	(!$s->{-pdta}->{$no}) {		# open button & exit
	$s->output($s->cgi->submit(-name=>$no, -value=>$s->lng(0,'ddlbopen'), -title=>$s->lng(1,'ddlbopen')));
	return('');
 }
 my $fs =sub{
	'{var k;'
	."var l=window.document.forms[0].$nl;"
	.(!$_[0]
	? "k=window.document.forms[0].$nf.value +String.fromCharCode(window.event.keyCode);"
	: $_[0] eq '1'
	? "window.document.forms[0].$nf.focus(); k=window.document.forms[0].$nf.value =String.fromCharCode(window.event.keyCode); "
	: $_[0] eq '2'
	? "k=prompt('Enter search string',String.fromCharCode(window.event.keyCode));"
	: $_[0] eq '3'
	? "k=prompt('Enter search substring',''); $nl.focus();"
	: $_[0] eq '4'
	? "k=window.document.forms[0].$nf.value; window.document.forms[0].$nl.focus();"
	: ''
	)
	.'if(!k){return(false)}; k=k.toLowerCase();'
	.'for (var i=0; i <l.length; ++i) {'
	.($s->cgi->user_agent('MSIE')
	?'if (l.options.item(i).value.toLowerCase().indexOf(k)'
		.($_[0] eq '3' ?'>=' :'==') .'0 || l.options.item(i).innerText.toLowerCase().indexOf(k)'
		.($_[0] eq '3' ?'>=' :'==') .'0){'
	:'if (l.options.item(i).value.toLowerCase().indexOf(k)'
		.($_[0] eq '3' ?'>=' :'==') .'0){')
	.'l.selectedIndex =i; break;}}'
	.($_[0] ? 'return(false);' : '')
	.'}'};
 $s->output('<script for="' .$nf .'" event="onkeypress()" >' .&$fs(0) ."</script>")
	if !$ml;
 $s->output($s->cgi->submit(-name=>$nc, -value=>$s->lng(0,'ddlbclose'), -title=>$s->lng(1,'ddlbclose')), "<br />\n");
 my $sl='<select name="' .$nl . '" size="10"'
	.' ondblclick="{' .($ml ? ($nl . '.nextSibling.nextSibling.click();') : !ref($tg) ? ($ne .'.focus();' .$ne .'.click();') : ($nl . '.nextSibling.nextSibling.click(); submit();')) .' return(true)}"'
	.(!$ml ? ' onkeypress="' .&$fs(1) .'"' : '')
	.'>';
 my $fmt =sub{length($_[0]) >60 ? substr($_[0],0,60) .'...' : $_[0]};
 if	(ref($d) eq 'ARRAY') {
	$s->output($sl, "\n");
	foreach my $e (@$d) {
		$s->output(
		 '<option value="' .htmlEscape($s, (ref($e) ? $e->[0] : $e)) .'">'
		,htmlEscape($s, &$fmt(ref($e) ? join(' - ', @$e) : $e))
		,"</option>\n")
	}
	$s->output("</select>");
 }
 elsif	(ref($d) eq 'HASH') {
	$s->output($sl, "\n");
	use locale;
	foreach my $e (sort {lc(ref($d->{$a}) ? join(' - ',@{$d->{$a}}) : $d->{$a}) 
			cmp  lc(ref($d->{$b}) ? join(' - ',@{$d->{$b}}) : $d->{$b})} 
			keys %$d) {
		$s->output(
		 '<option value="' .htmlEscape($s, (ref($e) ? $e->[0] : $e)) .'">'
		,htmlEscape($s, &$fmt(ref($d->{$e}) ? join(' - ', @{$d->{$e}}) : $d->{$e}))
		,"</option>\n")
	}
	$s->output("</select>");
 }
 elsif	($d &&
	($s->{-form} && $s->{-form}->{$d} 
	|| $s->mdeTable($d))) {
	$s->cgiList($d, undef, undef, undef, $sl)
 }
 else {
	$s->cgiList('', {}, {}, $d, $sl)
 }
 $s->output("<br />\n");
 if (ref($tg)) {
	foreach my $b (ref($tg) ? @$tg : $tg) {
		my ($n, $l, $m) =ref($b) ? @$b : ($b,$b,($b||'') =~/[+,;]/);
		   $n =$f->{-fld} if !defined($n);
		   $l =($m ? '<+' : '<') .$s->lng(0, $n) if !defined($l);
		my $f =($n =~/^[<+-]*(.+)/ ? $1 : $n);
		   $m =',' if $m && $m =~/^\d*$/;
		$s->output($s->cgi->button(
		  -value=>$l
		, -title=>$s->lng(1,'ddlbsubmit')
		, -onClick=>"{var fs =window.document.forms[0].$nl; "
			."var ft =window.document.forms[0].$f; "
			."var i  =fs.selectedIndex; i =i <0 ? 0 : i; "
			.($s->cgi->user_agent('MSIE')
			?(!$m	? "ft.value =(fs.options.item(i).value ==\"\" ? fs.options.item(i).text : fs.options.item(i).value);}"
				: "ft.value =(ft.value ==\"\" ? \"\" : (ft.value +\"$m\")) +(fs.options.item(i).value ==\"\" ? fs.options.item(i).text : fs.options.item(i).value);}")
			:(!$m	? "ft.value =fs[i].value;}"
				: "ft.value =(ft.value ==\"\" ? \"\" : (ft.value +\"$m\")) +fs[i].value;}")
			)
		))
	}
 }
 else {
	$s->output($s->cgi->submit(-name=>$ne, -value=>$s->lng(0,'ddlbsubmit'), -title=>$s->lng(1,'ddlbsubmit')));
 }
 $s->output($s->cgi->button(-value=>$s->lng(0,'ddlbfind'), -title=>$s->lng(1,'ddlbfind')
		,-onClick=>&$fs(3)
	));
 $s->output($s->cgi->submit(-name=>$nc, -value=>$s->lng(0,'ddlbclose'), -title=>$s->lng(1,'ddlbclose')),"\n");
 $s->output('<script for="window" event="onload">'
	.(!$ml ? &$fs(4) : "{window.document.forms[0].$nl.focus()}")
	."</script>\n");
}


sub cgiQKey {	# Make Query Key from fields filled
 my ($s, $n, $m, $v) =@_;
     $m =$s->{-form}->{$n}||$s->{-table}->{$n} if !$m;
 my $k ={};
 if	($m->{-query} && $m->{-query}->{-data}) {
	map {$k->{$_} =$v->{$_}
		} grep { defined($v->{$_}) && $v->{$_} ne ''
			} map {$_->{-fld}
				} grep {ref($_) eq 'HASH'
					} @{$m->{-query}->{-data}}
 }
 elsif	($m->{-field}) {
	map {$k->{$_} =	$v->{$_}
		} grep { defined($v->{$_}) && $v->{$_} ne ''
			} map {$_->{-fld}
				} grep {ref($_) eq 'HASH' && ($_->{-flg}||'') =~/[aql]/
					} @{$m->{-field}}
 }
 if (!%$k) {
	map {$k->{$_} =$v->{$_}
		} grep { defined($v->{$_}) && $v->{$_} ne ''
			} keys %{$v};
 }
 $k
}


sub cgiQuery {	# Query records
	# -query: rows & columns specs	; display specs
	#	+  resSel defaults		    for	recSel
	#	+ -qkey/key, -qwhere/where		cgiQuery
	#	+ -frmLso				cgiQuery
	#	- -frmLso, -frmLsc			cgiQuery
	#	+ -meta, -field				cgiSel: -data, -display
	#	+ -display	(,-data)		cgiList
	#       - -qhref, -qhrcol, -qfetch, -qfilter	cgiList
 my ($s, $n, $m, $c) =@_;
     $m =$s->{-form}->{$n}||$s->mdeTable($n) if !$m;
     $c =$s->{-pcmd} if !$c;
 my  $t =$m->{-table} && $s->mdeTable($m->{-table}) || $m;
 my  $q =$m->{-query};
						# Form Display Options Default
 if (exists($m->{-frmLso}) && !$m->{-frmLso}
 || ref($m->{-frmLso})) {
 }
 elsif (exists($t->{-frmLso}) 
 &&	!$t->{-frmLso}) {
 }
 elsif (ref($t->{-frmLso})) {
	$m->{-frmLso} =$t->{-frmLso}
 }
 elsif ($s->mdeRAC($m,'-qurole') 
 ||	$t->{-rvcDelState} || $s->{-rvcDelState} ||$t->{-rvcCkoState} ||$s->{-rvcCkoState}) {
	my $oe =($t->{-rvcChgState} ||$s->{-rvcChgState}) && $s->tn('-rvcChgState')->[1] ||'';
	my $oo =($t->{-rvcCkoState} ||$s->{-rvcCkoState}) && $s->tn('-rvcCkoState')->[1] ||'';
	my $od =($t->{-rvcDelState} ||$s->{-rvcDelState}) && $s->tn('-rvcDelState')->[1] ||'';
	my $ov =($t->{-rvcActPtr}   ||$s->{-rvcActPtr})   && 'tvmVersions';
	my $of =$oe && $od;
	my $ob =$t->{-rvcUpdWhen} && (($t->{-dbd} ||$s->{-dbd} ||$s->{-tn}->{-dbd}) eq 'dbi')
		&& (($q->{-order}||'') ne ($t->{-rvcUpdWhen} .' desc'));
	my $ou =[$s->mdeRoles($t)];
	my $oa =!(exists($m->{-frmLsoAdd}) && !$m->{-frmLsoAdd}) && ($m->{-frmLsoAdd}||$t->{-frmLsoAdd});
	$m->{-frmLso} =
		[(1 && @$ou 
		?(['-urole'		=>'-------------']) : ())
		,(grep {$_ ne 'all'} @$ou)
		,(1 && ($oe ||$oo ||$od ||$of ||$ov)
		?(['-todo'		=>'-------------']) : ())
		,($of ? (['todo'])	:())
		,($oe ? ([$oe])		:())
	#	,($oo ? ([$oo])		:())
		,($of ? (['done'])	:())
		,($od ? ([$od])		:())
		,($ov ? ([$ov])		:())
	#	,['recQBF' =>'...']
		];
	if (ref($oa) eq 'CODE') {
		&{$m->{-frmLsoAdd}||$t->{-frmLsoAdd}}($s, $n, $m, $c, exists($c->{-frmLso}) ? $c->{-frmLso}||'' : ())
	}
	elsif (ref($oa) eq 'ARRAY') {
		push @{$m->{-frmLso}}
			,(substr(ref($oa->[0]) eq 'HASH' ? $oa->[0]->{-val} : $oa->[0]->[0], 0, 1) 
				ne '-'
			? (['-add'	=>'-------------'])
			: ())
			, @$oa
	}
 }
						# Form Display Options Parser
 if ($m->{-frmLso}   ||($t->{-frmLso}   && !exists($m->{-frmLso}))
 ||  $m->{-frmLso0A} ||($t->{-frmLso0A} && !exists($m->{-frmLso0A}))) {
	my $ml =$m->{-frmLso} ||$t->{-frmLso};
	my $oe =($t->{-rvcChgState} ||$s->{-rvcChgState}) && $s->tn('-rvcChgState')->[1] ||'';
	my $oo =($t->{-rvcCkoState} ||$s->{-rvcCkoState}) && $s->tn('-rvcCkoState')->[1] ||'';
	my $od =($t->{-rvcDelState} ||$s->{-rvcDelState}) && $s->tn('-rvcDelState')->[1] ||'';
	my $ov =($t->{-rvcActPtr}   ||$s->{-rvcActPtr})   && 'tvmVersions';
	my $oa =($m->{-frmLsoAdd}||$t->{-frmLsoAdd});
	my $qo =($c->{-qkeyord} ||$q->{-keyord} ||'');
	if ($c->{-qkey} && ($oe || $oo || $od)) {
		foreach my $v	(map {$t->{$_} ||$s->{$_} ||$s->tn($_)
				} qw (-rvcChgState -rvcDelState -rvcFinState)) {
			$c->{-qkey}->{$v->[0]} =$s->datastr($c->{-qkey}->{$v->[0]})
				# !!! cgiQKey/cgiParse code not ready yet...
				if $c->{-qkey}->{$v->[0]}
				&& ($c->{-qkey}->{$v->[0]} =~/[,;]/)
		}
	}
	$c->{-frmLso} =ref($m->{-query}->{-frmLso}) eq 'CODE'
			? &{$m->{-query}->{-frmLso}}($s,$n,$m)
			: $m->{-query}->{-frmLso}
			if !exists($c->{-frmLso})
			&& $m->{-query} && $m->{-query}->{-frmLso};
	$c->{-frmLso} =$c->{-qurole}
			if !exists($c->{-frmLso})
			&& $c->{-qurole};
	$c->{-frmLso} =$m->{-query}->{-urole}
			if !exists($c->{-frmLso})
			&& !$s->uguest()
			&& $m->{-query} && exists($m->{-query}->{-urole});
	$c->{-frmLso} =''
			if !exists($c->{-frmLso});
	foreach my $lso (ref($c->{-frmLso}) 
			? @{$c->{-frmLso}} 
			: !exists($c->{-frmLso}) || !defined($c->{-frmLso}) 
			? ''
			: $c->{-frmLso}) {
	if ($m->{-frmLso0A}
	&& &{$m->{-frmLso0A}}($s, $n, $m, $c, exists($c->{-frmLso}) ? $lso||'' : ())) {
	}
	elsif ($t->{-frmLso0A} && ($m ne $t)
	&& &{$t->{-frmLso0A}}($s, $n, $t, $c, exists($c->{-frmLso}) ? $lso||'' : ())) {
	}
	elsif ($lso eq '-all') { # elsif (!$lso && exists($c->{-frmLso})) {
		delete $c->{-qurole};
		delete $c->{-qorder} if $t->{-rvcUpdWhen};
		foreach my $v	(map {$t->{$_} ||$s->{$_} ||$s->tn($_)
				} qw (-rvcChgState -rvcCkoState -rvcDelState -rvcFinState)) {
			if	(!ref($v) || !$c->{-qkey} || !defined($c->{-qkey}->{$v->[0]})) {}
			else	{
				delete $c->{-qkey}->{$v->[0]};
				delete $c->{-qversion};
				delete $c->{-qkeyord};
			}
		}
		delete $c->{-qversion};
		foreach my $e (ref($ml) eq 'ARRAY' 
				? @$ml
				: ref($ml) eq 'CODE'
				? @{&$ml($s, $n, $m, $c, exists($c->{-frmLso}) ? $c->{-frmLso} ||'' : ())}
				: ()) {
			next	if !ref($e);
			my $x =ref($e) eq 'HASH' ? $e->{-cmd} : $e->[2];
			next	if !$x
				|| (ref($x) ne 'HASH');
			delete @{$c}{keys %$x};
			delete @{$c->{-qkey}}{keys %{$x->{-qkeyadd}}}
				if $c->{-qkey} && $x->{-qkeyadd};
		}
	}
	elsif (do{	my $rv =undef;	
			foreach my $e (ref($ml) eq 'ARRAY' 
				? @$ml
				: ref($ml) eq 'CODE'
				? @{&$ml($s, $n, $m, $c, exists($c->{-frmLso}) ? $c->{-frmLso} ||'' : ())}
				: ()) {
				next	if !ref($e)
					|| ($lso ne (ref($e) eq 'HASH' ? $e->{-val} : $e->[0]));
				my $x =ref($e) eq 'HASH' ? $e->{-cmd} : $e->[2];
				next	if !$x;
				$rv =$x;
				last
			}
			if (ref($rv) eq 'CODE') {
				&$rv($s, $n, $m, $c, exists($c->{-frmLso}) ? $lso||'' : ())
			}
			elsif (ref($rv) eq 'HASH') {
				@{$c}{keys %$rv} =values %$rv;
				if ($c->{-qkeyadd}) {
					$c->{-qkey} ={}	if !$c->{-qkey};
					@{$c->{-qkey}}{keys %{$c->{-qkeyadd}}}
							=values %{$c->{-qkeyadd}};
					delete $c->{-qkeyadd}
				}
			}
			$rv
		}) {
	}
	elsif ($lso eq '-urole') {
		delete $c->{-qurole};
	}
	elsif ($s->grep1(sub{$lso eq $_}, $s->mdeRoles())) {
		$c->{-qurole}=$lso
	}
	elsif ($lso eq '-todo') {
		foreach my $v	(map {$t->{$_} ||$s->{$_} ||$s->tn($_)
				} qw (-rvcChgState -rvcCkoState -rvcDelState -rvcFinState)) {
			if	(!ref($v) || !$c->{-qkey} || !defined($c->{-qkey}->{$v->[0]})) {}
			else	{
				delete $c->{-qkey}->{$v->[0]};
				delete $c->{-qversion};
				delete $c->{-qkeyord};
			}
		}
		delete $c->{-qversion};
	}
	elsif ($lso eq 'todo') {
		delete $c->{-qversion};
		my $f =$t->{-rvcFinState} ||$s->{-rvcFinState} ||$s->tn('-rvcFinState');
		my $v =ref($f)
			? [$f->[0]
			  ,grep { my $v =$_; !grep {$v eq $_} @$f
				} @{$t->{-rvcAllState} ||$s->{-rvcAllState} ||$s->tn('-rvcAllState') ||[]}]
			: ($t->{-rvcChgState} ||$s->{-rvcChgState} ||$s->tn('-rvcChgState'));
		$c->{-qkey} ={}			if $v && !$c->{-qkey};
		$c->{-qkey}->{$v->[0]} =[@{$v}[1..$#{@$v}]]	if $v;
		$c->{-qkeyord} ='-aeq'	if $qo;
	}
	elsif ($lso eq 'done') {
		delete $c->{-qversion};
		my $v =$t->{-rvcFinState} ||$s->{-rvcFinState} ||$s->tn('-rvcFinState');
		if (!ref($v)) {
			my $f =[@{$t->{-rvcChgState} ||$s->{-rvcChgState} ||$s->tn('-rvcChgState') ||[]}, @{$t->{-rvcDelState} ||$s->{-rvcDelState} ||$s->tn('-rvcDelState') ||[]}];
			$v =[$f->[0]
			    ,grep { my $v =$_; !grep {$v eq $_} @$f
				} @{$t->{-rvcAllState} ||$s->{-rvcAllState} ||$s->tn('-rvcAllState') ||[]}]
		}
		$c->{-qkey} ={}			if $v && !$c->{-qkey};
		$c->{-qkey}->{$v->[0]} =[@{$v}[1..$#{@$v}]]	if $v;
		$c->{-qkeyord} ='-deq'	if $qo;
	}
	elsif ($oe && ($lso eq $oe)) {
		$c->{-qversion} ='+';
		my $v =$t->{-rvcChgState} ||$s->{-rvcChgState} ||$s->tn('-rvcChgState');
		$c->{-qkey} ={}			if $v && !$c->{-qkey};
		$c->{-qkey}->{$v->[0]} =[@{$v}[1..$#{@$v}]]	if $v;
		$c->{-qkeyord} ='-deq'	if $qo;
	}
	elsif ($oo && ($lso eq $oo)) {
		$c->{-qversion} ='+';
		my $v =$t->{-rvcCkoState} ||$s->{-rvcCkoState} ||$s->tn('-rvcCkoState');
		$c->{-qkey} ={}			if $v && !$c->{-qkey};
		$c->{-qkey}->{$v->[0]} =[@{$v}[1..$#{@$v}]]	if $v;
		$c->{-qkeyord} ='-deq'	if $qo;
	}
	elsif ($od && ($lso eq $od)) {
		$c->{-qversion} ='+';
		my $v =$t->{-rvcDelState} ||$s->{-rvcDelState} ||$s->tn('-rvcDelState');
		$c->{-qkey} ={}			if $v && !$c->{-qkey};
		$c->{-qkey}->{$v->[0]} =[@{$v}[1..$#{@$v}]]	if $v;
		$c->{-qkeyord} ='-deq'	if $qo;
	}
	elsif ($ov && ($lso eq $ov)) {
		$c->{-qversion} ='+';
	}
	elsif ($lso eq '-add') {
		foreach my $e (ref($oa) eq 'ARRAY' ? @$oa : ()) {
			next	if !ref($e);
			my $x	=ref($e) eq 'HASH' ? $e->{-cmd} : $e->[2];
			next	if !$x || (ref($x) ne 'HASH');
			delete @{$c}{keys %$x};
			delete @{$c->{-qkey}}{keys %{$x->{-qkeyadd}}}
				if $c->{-qkey} && $x->{-qkeyadd};
		}
	}}
	$c->{-frmLso} =$c->{-frmLso}->[0]	if ref($c->{-frmLso});
 }

 my  %a =$q ? %$q : ();				# Query Arguments
						# Query Key
 $c->{-qkey} 	=ref($q->{-qkey}) eq 'CODE'
		? &{$q->{-qkey}}($s, $n, $m, $c)
		: $q->{-qkey}	if $q->{-qkey}	&& !$c->{-qkey};
 $a{-key} 	={}		if $q->{-key}	||  $c->{-qkey};
 @{$a{-key}}{keys %{$q->{-key}}}	=values %{$q->{-key}}	  if $q->{-key};
 @{$a{-key}}{keys %{$c->{-qkey}}}	=values %{$c->{-qkey}}	  if $c->{-qkey};
 $a{-data}				=[@{$q->{-data}}]	  if $q->{-data};
 $a{-display}				=[@{$q->{-display}}]	  if $q->{-display};
 $a{-field}				=[@{$q->{-field}}]	  if $q->{-field};

						# Query Where
 $c->{-qwhere}	=ref($q->{-qwhere}) eq 'CODE'
		? &{$q->{-qwhere}}($s, $n, $m, $c)
		: $q->{-qwhere}		if $q->{-qwhere} && !$c->{-qwhere};
 if	(!$c->{-qwhere})		{}
 elsif	(!$a{-where})			{$a{-where} =$c->{-qwhere}}
 elsif	(ref($a{-where}) eq 'ARRAY')	{push @{$a{-where}}, $c->{-qwhere}}
 elsif	(ref($a{-where}))		{$a{-where} =$c->{-qwhere}}
 else					{$a{-where} ='(' .$a{-where} .') and (' .$c->{-qwhere} .')'}

 $a{-meta}	=$m;                            # Query Other Clauses
 $a{-table}	=$m->{-table} ||$n	if !$a{-table};
 $a{-urole}	=$c->{-qurole}		if exists($c->{-qurole});
 $a{-uname}	=$c->{-quname}		if exists($c->{-quname});
 $a{-ftext}	=$c->{-qftext}		if $c->{-qftext};
 $a{-version}	=$c->{-qversion}	if $c->{-qversion};
 $a{-order}	=$c->{-qorder}		if $c->{-qorder};
 $a{-keyord}	=$c->{-qkeyord}		if $c->{-qkeyord};
 $a{-limit}	=$c->{-qlimit}		if $c->{-qlimit};

 if (exists($m->{-frmLsc}) ? $m->{-frmLsc} : ($m->{-frmLsc} ||$t->{-frmLsc})) {
	if (!$a{-data} && ($m ne $t) && $t->{-query}) {
		my $q =$t->{-query};
		$a{-data}	=[@{$q->{-data}}]
				if !$a{-data} && ref($q->{-data});
		$a{-display}	=[@{$q->{-display}}]
				if !$a{-display} && ref($q->{-display});
		$a{-field}	=[@{$t->{-field}}]
				if !$a{-field} && ref($t->{-field});
	}
	my $lsc =$m->{-frmLsc} ||$t->{-frmLsc};
	my $lsq =$c->{-frmLsc} ||(ref($lsc->[0]) eq 'HASH' ? $lsc->[0]->{-val} : $lsc->[0]->[0]);
	foreach my $e (@$lsc) {
		next if $lsq ne (ref($e) eq 'HASH' ? $e->{-val} : $e->[0]);
		my $x =ref($e) eq 'HASH' ? $e->{-cmd} : $e->[2];
		if (ref($x) eq 'CODE') {
			&$x($s, $n, $m, \%a, $lsq);
			last;
		}
		@a{keys %$x} =values %$x;
		if ($x->{-keyadd}) {
			$a{-key} ={}	if !$a{-key};
			@{$a{-key}}{keys %{$x->{-keyadd}}}
					=values %{$x->{-keyadd}};
			delete $a{-keyadd}
		}
		last;
	}
 }

   $m->{-frmLso0C}
 ? &{$m->{-frmLso0C}}($s, $n, $m, \%a, exists($c->{-frmLso}) ? $c->{-frmLso}||'' : ())
 : $t->{-frmLso0C} && !exists($m->{-frmLso0C})
 ? &{$t->{-frmLso0C}}($s, $n, $t, \%a, exists($c->{-frmLso}) ? $c->{-frmLso}||'' : ())
 : undef;

 $s->cgiSel(\%a);
}


sub cgiSel {	# Select records from database
 my $q =ref($_[1]) ? $_[1] : {@_[1..$#_]};
 local  $q->{-meta} =
	  ref($q->{-meta})
	? $q->{-meta}
	: $q->{-meta}
	? $_[0]->{-form}->{$q->{-meta}} || $_[0]->mdeTable($q->{-meta})
	: !$q->{-table}
	? undef
	: !ref($q->{-table}) && ($q->{-table} =~/^([^\s]+)/)
	? $_[0]->{-form}->{$1} || $_[0]->mdeTable($1)
	: ref($q->{-table}->[0])
	? $_[0]->mdeTable($q->{-table}->[0]->[0])
	: ($q->{-table}->[0] =~/^([^\s]+)/)  && $_[0]->mdeTable($1);
 local  $q->{-data}	=$q->{-data};
 local  $q->{-field}	=$q->{-field};
 local  $q->{-display}	=$q->{-display};
 foreach my $n ($q, $q->{-meta}, $q->{-meta} && $q->{-meta}->{-table}) {
	last	if $q->{-data};
	next	if !$n;
	my $m =ref($n) ? $n : $_[0]->mdeTable($n);
	next	if !$m;
	# $_[0]->logRec('***cgiSel/inherit',$m->{-lbl} || 'query');
	$q->{-field}=$m->{-field}
		if !$q->{-field};
	$q->{-data} =
		   $m->{-data}
		|| $m->{-query}->{-data}
		|| ($m->{-field}
		&& [grep {ref($_) eq 'HASH' 
			&& $_->{-fld}
			&& (	  (($_->{-flg}||'') =~/[akwql]/)
				||(!defined($_->{-flg})
					&& (ref($_->{-inp}) ne 'HASH') 
						? 1 
						: !(	  $_->{-inp}->{-rows}
							||$_->{-inp}->{-arows}
							||$_->{-inp}->{-rfd})
					)
				)
			} @{$m->{-field}}])
		if !$q->{-data} && $m->{-field};
	$q->{-display}=$m->{-display} 
		||($m->{-query} && $m->{-query}->{-display})
		if !$q->{-display};
	$q->{-display}=[map {	   (ref($_) ne 'HASH') 
				|| (($_->{-flg}||'') !~/[al]/i)
				|| !$_->{-fld}
				? ()
				: $_->{-fld}
				} @{$q->{-data}}]
		if !$q->{-display} && $q->{-data};
 }
 delete $q->{-meta}	if !$q->{-meta};
 delete $q->{-field}	if !$q->{-field}	|| !@{$q->{-field}};
 delete $q->{-data}	if !$q->{-data}		|| !@{$q->{-data}};
 delete $q->{-display}	if !$q->{-display}	|| !@{$q->{-display}};
 $_[0]->recSel($q)
}


sub cgiList {	# List queried records
		# self, ?options, form name, ?metadata, ?command, ?iterator, ?borders
 my ($s, $o, $n, $m, $c, $i, $b) =($_[0], substr($_[1],0,1) eq '-' ? @_[1..$#_] : ('-', @_[1..$#_]));
    $m  =$s->{-form}->{$n}||$s->mdeTable($n)||{} if !$m;
    $c  =$s->{-pcmd}||{} if !$c;
 $i =	  !$i 
	? $s->cgiSel(%{$m->{-query}}, -form=>$n)
	: ref($i) eq 'HASH'
	? $s->cgiSel($i)
	: ref($i) eq 'ARRAY'
	? eval{my $a =$i; DBIx::Web::ccbHandle->new(sub{shift @$a})}
	: ref($i) eq 'CODE'
	? DBIx::Web::dbmCursor->new($i)
	: $i;
 $i ||return(&{$s->{-die}}('cgiList(' .strdata(@_) .') -> cursor undefined'));
 my $xml=$c->{-xml};
 my $mt =$m->{-table} && $s->mdeTable($m->{-table}) || $m;
 my $mf =  $c->{-field} || $m->{-field} || $mt->{-field};
 my $hstl  ='class="'
		.(!$b ? 'ListTable' : 'ListList')
		.($s->{-uiclass} ? ' ' .$s->{-uiclass} : '')
		.'"'
		.($s->{-uistyle} ? ' style="' .$s->{-uistyle} .'"' : '');
 my $disp  =$c->{-qdisplay}	|| ($i && $i->{-query} && $i->{-query}->{-display})
				|| $m->{-qdisplay};
 my $href  =$c->{-qhref} ||$m->{-qhref} ||{};
    $href->{-form} =$m->{-table}||$n	if (ref($href) eq 'HASH') && !$href->{-form};
    $href->{-cmd}  ='recRead'		if (ref($href) eq 'HASH') && !$href->{-cmd};
	# -formfld, -key
 my $hrcol =(defined($c->{-qhrcol}) ? $c->{-qhrcol} : $m->{-qhrcol}) || 0;
 my @colf  =();		# col fields: name, number, heading, td, struct
 my $coln  =sub{return($_[1]) if !$i->{NAME};
		my $n =lc(ref($_[0]) ? $_[0]->{-fld} : $_[0]);
		for(my $k =0; $k <=$#{$i->{NAME}}; $k++) {
			return($k) if $n eq lc($i->{NAME}->[$k])};
		$#{$i->{NAME}} +1};
 my $qflgh =$o =~/!.*h/ && ($c->{-qflghtml} || $m->{-qflghtml});
    $qflgh ="<span $hstl>" .$qflgh .'</span>' if $qflgh && $hstl;
 my $tstrt =undef;
 my $fetch =$c->{-qfetch} || $m->{-qfetch};
 my $limit =$c->{-qlimit} || ($m->{-query} && $m->{-query}->{-limit}) ||$m->{-limit} ||$s->{-limit} ||$LIMRS;

 $b =	  $xml
	? ["\n<table>\n"
		,"<tr>\n",	    '<td>',			   '<url>',	'</url>',' ',	"</td>\n","</tr>\n","</table>\n"]
	: !$b
	? ["\n<table $hstl>\n"
		,"<tr>\n",	    "<td align=\"left\" valign=\"top\" $hstl>","<a $hstl href=\"", '">', '</a>', "</td>\n", "</tr>\n", "</table>\n"]
	: $b =~/<select/
	? [$b	,'<option value="', '',				    '">',	 '',	'',	'',	"</option>\n",	"</select>\n"]
	: ["<span $hstl>"
		,' ',' '," <a $hstl href=\"",'">','</a> ',' ',"$b\n","</span>\n"]
	if !ref($b);

 if (ref($href) eq 'HASH') {
	if	(!$href->{-key}) {		# Hyperlink key
		$href->{-key} =[];
		my $j =0;
		my $k =(ref($m->{-key}) eq 'ARRAY') && $m->{-key};
		foreach my $f (@$mf) {
			next if ref($f) ne 'HASH' ||!$f->{-fld};
			push @{$href->{-key}}, [$f->{-fld} =>&$coln($f,$j)]
				if ($f->{-flg}||'') =~/[k]/	# 'k'ey
				|| ($k
				&&  grep {$f->{-fld} eq $_} @$k);
			$j++
		}
	}
	elsif((ref($href->{-key}) eq 'ARRAY') || !ref($href->{-key})) {
		foreach my $k (ref($href->{-key}) ? @{$href->{-key}} : ($href->{-key})) {
			next if ref($k);
			if ($i->{NAME}) {
				$k =ref($href->{-key}) ? [$k, &$coln($k)] : &$coln($k);
				next
			}
			my $j =0;
			foreach my $f (@$mf) {
				next if ref($f) ne 'HASH' ||!$f->{-fld};
				if ($k eq $f->{-fld}) {
					$k =ref($href->{-key}) ? [$k, $j] : $j;
					last
				}
				$j++
			}
		}
	}
	if	(!$href->{-urm}) {		# Hyperlink unread mark
		$href->{-urm} =[];
		my $j =0;
		my $k =((ref($m->{-urm})  eq 'ARRAY') && $m->{-urm})
		    || ((ref($m->{-wkey}) eq 'ARRAY') && $m->{-wkey});
		foreach my $f (@$mf) {
			next if ref($f) ne 'HASH' ||!$f->{-fld};
			push @{$href->{-urm}}, [$f->{-fld} =>&$coln($f,$j)]
				if ($f->{-flg}||'') =~/[w]/	# 'w'here key
				&& ($f->{-flg}||'') !~/[k]/	# 'k' key
				|| ($k
				&&  grep {$f->{-fld} eq $_} @$k);
			$j++
		}
	}
	elsif ((ref($href->{-urm}) eq 'ARRAY') || !ref($href->{-urm})) {
		foreach my $k (ref($href->{-urm}) ? @{$href->{-urm}} : $href->{-urm}) {
			next if ref($k);
			if ($i->{NAME}) {
				$k =ref($href->{-urm}) ? [$k, &$coln($k)] : &$coln($k);
				next
			}
			my $j =0;
			foreach my $f (@$mf) {
				next if ref($f) ne 'HASH' ||!$f->{-fld};
				if ($k eq $f->{-fld}) {
					$k =ref($href->{-urm}) ? [$k, $j] : $j;
					last
				}
				$j++
			}
		}
	}
	if	($href->{-formfld}) {		# Hyperlink form
		my $j =0;
		if ($i->{NAME}) { 
			$j =&$coln($href->{-formfld});
			$href->{-form} =sub{$_[1]->[$j]}
		}
		else {	foreach my $f (@$mf) {
				next if ref($f) ne 'HASH' ||!$f->{-fld};
				if (($f->{-fld}||'') eq $href->{-formfld}) {
					$href->{-form} =sub{$_[1]->[$j]};
					last
				}
				$j++
			}
		}
	}
	elsif	(defined($href->{-formfld})) {
		$href->{-form} =''
	}
	if	(1) {				# Hyperlink sub{}
		my $hr	=$href;
		$href	=sub{
			 '?' .'_cmd='  .urlEscape($s
				, ref($hr->{-cmd})  ne 'CODE' 
				? $hr->{-cmd}  : (&{$hr->{-cmd}}(@_)))
			.$HS .'_form=' .urlEscape($s
				, ref($hr->{-form}) ne 'CODE' 
				? $hr->{-form} : (&{$hr->{-form}}(@_)))
			.$HS .'_key='  .urlEscape($s
				, !ref($hr->{-key})
				? $_[1]->[$hr->{-key}]
				: ref($hr->{-key}) ne 'CODE'
				? strdatah($s, map {($_->[0] => $_[1]->[$_->[1]])} @{$hr->{-key}})
				: &{$hr->{-key}}(@_))
			.$HS .'_urm='  .urlEscape($s
				, !ref($hr->{-urm})
				? $_[1]->[$hr->{-urm}]
				: ref($hr->{-urm}) ne 'CODE'
				? join(',',map {$_[1]->[$_->[1]] ? ($_[1]->[$_->[1]]) : ()} @{$hr->{-urm}})
				: &{$hr->{-urm}}(@_))
		};
	}
 }
 $href =sub{''} if !$href;

 if (!@colf)	{				# Display column numbers
	my $j =0;
	foreach my $e ($disp ? @$disp : $i->{NAME} ? @{$i->{NAME}} : @$mf) {
		my $f =undef;
		if ($disp || $i->{NAME}) {
			foreach my $v (@$mf) {
				next	if ref($v) ne 'HASH' 
					||!$v->{-fld}
					||lc($v->{-fld}) ne $e;
				$f =$v;	last
			}
			$f ={-fld=>$e} if !$f
		}
		else {
			next if ref($e) ne 'HASH' ||!$e->{-fld};
			$f =$e
		}
		$j =&$coln($f, $j);
		push @colf
		, [$f->{-fld} || ''
		, ref($f->{-lsthtml}) eq 'CODE'
		? do{	my($i, $c) =($j, $f->{-lsthtml});
			sub{local $_=ref($_[2]) ?$_[2]->[$i] :$_[2]; &$c}
			}
		: $j
		, $s->lnglbl($f, '-fld')||''
		, !$b->[2]	|| $xml 
				|| (!$f->{-ldclass} && !$f->{-ldstyle} && !$f->{-ldprop}) 
				|| ($b->[2] !~/^<.*>$/)
		? $b->[2]
		: do {	my $v =$b->[2];
			$v =~/\sclass\s*=\s*"/
			? $v =~s/\sclass\s*=\s*"([^"]*)"/' class="' .$1 .' ' .$f->{-ldclass} .'"'/ie
			: $v =~s/^(.+)(>)$/$1 .' class="' .$f->{-ldclass} .'"' .$2/ie
				if $f->{-ldclass};
			$v =~/\sstyle\s*=\s*"/
			? $v =~s/\sstyle\s*=\s*"([^"]*)"/' style="' .$1 .'; ' .$f->{-ldstyle} .'"'/ie
			: $v =~s/^(.+)(>)$/$1 .' style="' .$f->{-ldstyle} .'"' .$2/ie
				if $f->{-ldstyle};
			$v =~s/^(.+)(>)$/$1 .' ' .$f->{-ldprop} .'>'/ie
				if $f->{-ldprop};
			$v }
		, $f]
		if $disp || $f->{-lsthtml} || (($f->{-flg}||'') =~/[l]/);
		$j++
	}
	if (!@colf && isa($i, 'HASH'))	{
		@colf	=map {[$i->{NAME}->[$_], $_, $i->{NAME}->[$_], $b->[2], {}]} (0..$#{$i->{NAME}});
		foreach my $h (@colf) {
			foreach my $f (@$mf) {
				next if ref($f) ne 'HASH' ||!$f->{-fld} ||$f->{-fld} ne $h->[2];
				$h->[2] =$s->lnglbl($f,'-fld')||''
			}
		}
	}
 }

 $tstrt =sub{					# Table start sub{}
	$s->output($b->[0]);
	if ($xml || !@colf || $b->[0] !~/<table/i) {
	}
	elsif ($o !~/!.*h/) {			# Table header
		my $tho;
		if ($m->{-frmLsc}
		|| ($mt->{-frmLsc} && !exists($m->{-frmLsc}))) {
			my $lsc =$m->{-frmLsc} ||$mt->{-frmLsc};
			my $lsf =$mt->{-mdefld} ||{};
			$tho =[@{$colf[0]}];
			$tho->[2] = sub{
				use locale;
				my $lsq =$_[0]->{-pcmd}->{-frmLsc} 
					||(ref($lsc->[0]) eq 'HASH' 
						? $lsc->[0]->{-val} 
						: $lsc->[0]->[0]);
				"<select name=\"_frmLsc\" class=\"ListTable\" onchange=\"{_cmd.value='recList'; submit()}\">\n"
				.join('', map {	
					my ($v,$l) =ref($_) eq 'HASH' 
						? ($_->{-val}, $_[0]->lnglbl($_)) 
						: ($_->[0], $_->[1]);
					$l =ucfirst($lsf->{$v}
						&& $_[0]->lnglbl($lsf->{$v})
						|| $_[0]->lng(0,$v))
						if !$l;
					'<option'
					.($v eq $lsq ? ' selected' : '')
					.' class="ListTable" value="'
					.$_[0]->htmlEscape($v)
					.'">'
					.$_[0]->htmlEscape($l)
					."</option>\n"} @$lsc)
				."</select>\n"
			}
		}
		elsif ($m->{-frmLso2C}
		|| ($mt->{-frmLso2C} && !exists($m->{-frmLso2C}))) {
			$tho =[@{$colf[0]}];
			$tho->[2] =$m->{-frmLso2C} ||$mt->{-frmLso2C};
		}
		$s->output("<tr>\n"
		, (map {('<th align="left" valign="top" class="ListTable'
			.($_->[4]->{-lhclass} ? ' ' .$_->[4]->{-lhclass} .'"': '"')
			.($_->[4]->{-lhstyle} ? ' style="' .$_->[4]->{-lhstyle} .'"' : '')
			.' title="' .htmlEscape($s, lngcmt($s, $_->[4]) ||$s->lng(1, $_->[0]) ||$_->[2]) .'"'
			.($_->[4]->{-lhprop} ? ' ' .$_->[4]->{-lhprop} : '')
			.'>'
			,ref($_->[2]) 
			? &{$_->[2]}($s, $n, $m, $c)
			: htmlEscape($s, $_->[2])
			,"</th>\n")} $tho ? ($tho, @colf[1..$#colf]) : @colf)
		, "</tr>\n")
	}
	elsif (0 && $b->[0] =~/<table/i) {	# Compatible empty header
		$s->output("<tr>\n"	
		, (map {('<th align="left" valign="top" class="ListTable'
			.($_->[4]->{-lhclass} ? ' ' .$_->[4]->{-lhclass} .'"': '"')
			.($_->[4]->{-lhstyle} ? ' style="' .$_->[4]->{-lhstyle} .'"' : '')
			.($_->[4]->{-lhprop}  ? ' ' .$_->[4]->{-lhprop} : '')
			,"></th>\n")} @colf)
		, "</tr>\n")
	}
 };

 if (ref($fetch) ne 'CODE') {			# Fetch sub{}
	my $ft	=$fetch;
	my $hrc1=$hrcol+1; # $b->[4] || $#colf ? $hrcol+1 : $hrcol;
	$fetch	=sub {
		my $r;
		while($r =$i->fetch()) {
			last	if !$m->{-qfilter} 
				|| &{$m->{-qfilter}}($s, $n, $m, $c, $i->{-rec})
		}
		return(undef)	if !$r;
		if ($qflgh) {
			$s->output((ref($qflgh) eq 'CODE' ? &$qflgh($s) : $qflgh));
			&$tstrt();
			$qflgh =undef
		}
		my $h =&$href($s, $r);
		$xml
		? $s->output(''
		, xmlsTag($s, 'tr', 'href'=>$s->cgi->url() .'/' .$h, '0')
		, "\n"
		, (map {xmlsTag($s, $_->[0]
				, ''=>	  ref($_->[1])
					? &{$_->[1]}($s, $r)
					: ref($r)
					? $r->[$_->[1]]
					: $r
				, "\n")
			} @colf)
		,$b->[7])
		: $s->output($b->[1]
		, (map {!ref($_->[1])
			? (	  $_->[3] ||htmlEscBlnk($s, ref($r) ? $r->[$_->[1]] : $r)
				, $b->[3]
				, $b->[4] && $h, $b->[4]
				, ref($_->[1]) 
				? &{$_->[1]}($s, $i, $r, $h)
				: htmlEscBlnk($s, ref($r) ? $r->[$_->[1]] : $r)
				, $b->[5], $b->[6])
			: &$_($s, $i, $r, $h)
			} @colf[0..$hrcol])
		, (map { !ref($_->[1])
			? (	  $_->[3]  # $b->[2]
				, ref($_->[1])
				? &{$_->[1]}($s, $i, $r)
				: htmlEscape($s, ref($r) ? $r->[$_->[1]] : $r)
				, $b->[6])
			: &{$_->[1]}($s, $i, $r)
			} @colf[$hrc1..$#colf])
		,$b->[7])
	}
 }

 &$tstrt() if !$qflgh;				# Table start

 my $j =0;
 while (&$fetch($s, $i, $b)) {			# Fetch data
	$j++;
	last if $j >$limit;
 }
 $s->{-fetched} =$j;
 $s->{-limited} =$limit;
 eval {$i->finish};

 $s->output($b->[8]) if !$qflgh;		# Table end
}


sub cgiFooter {	# Footer of CGI screen
 my ($s) =@_;
 return(undef) if $s->{-pcmd}->{-xml} ||$s->{-pcmd}->{-print};
 $s->output("\n"
#	,'<span class="FooterArea">'
#	,'<hr class="FooterArea" onclick="{_FooterArea.style.display=(_FooterArea.style.display==\'none\' ? \'inline\' : \'none\')}" style="cursor: hand; " />'
	,'<span class="FooterArea" onclick="{_FooterArea.style.display=(_FooterArea.style.display==\'none\' ? \'inline\' : \'none\')}" style="cursor: hand; ">'
	,'<hr class="FooterArea" />'
	,"\n"
	,($s->cgiHook('recList') && defined($s->{-fetched})
	? ('<b>',$s->{-limited} && ($s->{-limited} <=$s->{-fetched})
		?($s->{-limited}, ' / ?')
		:($s->{-fetched}||0)
		,' ', $s->lng(1, '-fetched'),"</b><br />\n")
	: defined($s->{-affected})
	? ('<b>',$s->{-affected}||0, ' ', $s->lng(1, '-affected'),"</b><br />\n")
	: ())
	, '<span id="_FooterArea" class="FooterArea" style="display: ' .($s->{-debug} && $s->{-debug} >1 ? 'inline' : 'none') .'; font-size: small; ">'
	, $s->{-c}->{-logm} && $s->{-debug}
	&& join(";<br />\n",
		map {	$_ =~/^((?:WARN|WARNING|DIE|ERROR)[:.,\s]+)(.*)$/i
			? '<strong class="FooterArea ErrorMessage">' .htmlEscape($s, $1) .'</strong>' .htmlEscape($s, $2)
			: htmlEscape($s, $_)
			} @{$s->{-c}->{-logm}}
		)
	,"</span></span>\n");
}


#########################################################
# Templates or Default Data Definitions
#########################################################


sub tn {	# Template Naming
		# (self, metaname) -> name
   (($#_ <1) && $_[0]->{-tn})
|| ($_[0]->{-tn}->{$_[1]})
|| (substr($_[1],0,1) eq '-' ? substr($_[1],1) : $_[1])
}


sub tfoShow {	# Template Field Option '-lblhtml' to Show all details absent
		# (self, ? input name, ? [detail fields], ? html pattern)
 my ($s, $n, $d, $h) =@_;
 sub{	my $x =!$h ? '$_' : ref($h) eq 'CODE' ? &$h(@_) : $h;
	   $_[3]
	|| $_[0]->{-pdta}->{$n||'tfoShow_'}
	|| ($d && !grep {!$_[0]->{-pout}->{$_}} @$d)
	? $x
	: ($x
	  .'<input type="submit" name="' .($n||'tfoShow_')
	  .'" value="' .$_[0]->lng(0,'ddlbopen') 
	  .'" title="' .$_[0]->lng(1,'ddlbopen') 
	  .'" />')
 }
}


sub tfoHide {	# Template Field Option '-hide' details absent
		# (self, ? input name)
 my ($s, $n) =@_;
 sub {!($_ || $_[0]->{-pdta}->{$n||'tfoShow_'} ||$_[3])}
}



sub tfdRFD {	# Template Field Definition for Record File Directory
		# self, ? definition
 my ($s) =@_; return
 {-fld=>''
 ,-flg=>'e'	# 'e'dit
 ,-lbl=>sub{$_[0]->lng(0,'rfafolder')}
 ,-cmt=>sub{$_[0]->lng(1,'rfafolder')}
 ,-lblhtml=> sub {
	return('') if !$s->{-pout}->{-file};
	'<a href="' 
	.($s->rfdPath(-urf=>$s->{-pcmd}, $s->{-pout}) ||$s->rfdPath(-url=>$s->{-pcmd}, $s->{-pout}))
	.'" target="_blank" '
	.' title="' .$s->htmlEscape($s->lng(1,'rfafolder')) 
	.'" style="behavior:url(\'#default#httpFolder\')">'
	.($s->{-icons} && $IMG->{'rfafolder'}
	 ? '<img src="' .$s->{-icons} .'/' .$IMG->{'rfafolder'} .'" border=0 style="behavior:url(\'#default#httpFolder\')"/>'
		.'</a> '
	 : $s->htmlEscape($s->lng(0,'rfafolder')) .'</a>: ');
 }
 ,-inp=>{-rfd=>1}
 ,@_ > 1 ? @_[1..$#_] : ()
 }
}


sub ttoRVC {	# Template Table Option for Record Version Control
	(-key		=> $_[0]->{-tn}->{-key}
	,-rvcInsBy	=> $_[0]->{-tn}->{-rvcInsBy}
	,-rvcInsWhen	=> $_[0]->{-tn}->{-rvcInsWhen}
	,-rvcUpdBy	=> $_[0]->{-tn}->{-rvcUpdBy}
	,-rvcUpdWhen	=> $_[0]->{-tn}->{-rvcUpdWhen}
	,-rvcActPtr	=> $_[0]->{-tn}->{-rvcActPtr}
	,-rvcChgState	=> $_[0]->{-tn}->{-rvcChgState}
	,-rvcCkoState	=> $_[0]->{-tn}->{-rvcCkoState}
	,-rvcDelState	=> $_[0]->{-tn}->{-rvcDelState}
	,@_ > 1 ? @_[1..$#_] : ())
}


sub tvmVersions {	# Template for Materialized View of Versions of records
			# 'versions' materialized view default definition
			# self, ? fields, ? definitions
	my $s =$_[0]; return($s->{-tn}->{'tvmVersions'}=>
	{-lbl	=>	sub{$_[0]->lng(0,'tvmVersions')}
	,-cmt	=>	sub{$_[0]->lng(1,'tvmVersions')}
	,-field	=>	[
		 {-fld=>'table',			-edit=>0, -flg=>'uql'}
		,{-fld=>$s->{-tn}->{-rvcActPtr},	-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>'id',				-edit=>0, -flg=>'uql'}
		,{-fld=>$s->{-tn}->{-rvcInsWhen},	-edit=>0, -flg=>'uq'}
		,''
		,{-fld=>$s->{-tn}->{-rvcInsBy},		-edit=>0, -flg=>'uq'}
		,{-fld=>$s->{-tn}->{-rvcUpdWhen},	-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>$s->{-tn}->{-rvcUpdBy},		-edit=>0, -flg=>'uql'}
		,{-fld=>$s->{-tn}->{-rvcState},		-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>'subject',			-edit=>0, -flg=>'uql'}
		,{-fld=>'readers',			-edit=>0, -flg=>'u'}
		,{-fld=>'cargo',			-edit=>0, -flg=>'u'}
		,ref($_[1]) eq 'ARRAY' ? @{$_[1]} : ()
		]
	,-key	=>	['table',$s->{-tn}->{-rvcActPtr},'id']
	,-racReader=>	['readers']
	,-rvcInsBy=>	$s->{-tn}->{-rvcInsBy}
	,-rvcUpdBy=>	$s->{-tn}->{-rvcUpdBy}
	,-rvcActPtr=>	$s->{-tn}->{-rvcActPtr}
	,-query	=>	{-version=>'+'}
	,-ixcnd	=>	sub{$_[2]->{'id'}}
	,-ixrec	=>	sub{my $m =$_[0]->{-table}->{$_[1]->{-table}};
		return(
		{'table'	=>$_[1]->{-table}
		,$s->{-tn}->{-rvcActPtr}	=>$m->{-rvcActPtr} && $_[2]->{$m->{-rvcActPtr}}
		,'id'		=>$_[2]->{'id'}
		,$s->{-tn}->{-rvcInsWhen}=>$m->{-rvcInsWhen} && $_[2]->{$m->{-rvcInsWhen}}
		,$s->{-tn}->{-rvcInsBy}	 =>$m->{-rvcInsBy}   && $_[2]->{$m->{-rvcInsBy}}
		,$s->{-tn}->{-rvcUpdWhen}=>$m->{-rvcUpdWhen} && $_[2]->{$m->{-rvcUpdWhen}}
		,$s->{-tn}->{-rvcUpdBy}	 =>$m->{-rvcUpdBy}   && $_[2]->{$m->{-rvcUpdBy}}
		,$s->{-tn}->{-rvcState}	 =>$m->{-rvcChgState}&& $_[2]->{$m->{-rvcChgState}->[0]}
		,'subject'	=>join(' '
				,(map {$_[2]->{$_}
					} grep {$_[2]->{$_}
						} qw(record object subject))
				)
		,'readers'	=>join(',', map {$_[2]->{$_}||''} 
				grep {$_[2]->{$_}} 
				@{$m->{-racReader}||$_[0]->{-racReader}||[]}
				, @{$m->{-racWriter}||$_[0]->{-racWriter}||[]})
		,'cargo'	=>join("\t",map {$_[2]->{$_}||''} 
				grep {$_[2]->{$_}} keys %{$_[2]})
		})}
	,-qhref	=>	{-formfld	=>'table'
			,-key		=>['id']	# [['id'=>2]]
			}
	,@_ > 2 ? @_[2..$#_] : ()
	})
}


sub tfvVersions {	# Template for Field View of Versions of records
 my ($s, $f, @o) =@_;	# (self, ? fields, ? definitions)
 my $v =$s->{-tn}->{'tvmVersions'};
 sub{	
	return('')	if ($_[0]->{-pcmd}->{-cmg} eq 'recQBF')
			|| !$_[0]->{-pcmd}->{-table}
			|| !$_[0]->{-pout}->{'id'}
			|| $_[0]->{-pcmd}->{-print};
	my $q =($_[0]->{-table}->{$_[0]->{-pcmd}->{-table}}->{-dbd} ||$_[0]->{-dbd}) eq 'dbi';
	$v =$_[0]->{-pcmd}->{-table} if $q;
	local $s->{-uiclass} ='tfvVersions';
	local $s->{-uistyle} ='font-size: small';
	$_[0]->cgiList('-!h'
		,$v
		,undef
		,{-qhrcol=>1, -qflghtml=>$_[0]->cgi->hr() .$_[0]->lng(0,'tvmVersions') .': '}
		,{-key=>{$q ? () : ('table'=>$_[0]->{-pcmd}->{-table})
			,$_[0]->{-tn}->{-rvcActPtr}=>$_[0]->{-pout}->{'id'}}
		 ,-table=>$v
		 ,-order=>$q ? [[$_[0]->{-tn}->{-rvcUpdWhen}=>'desc']] : '-deq'
		 ,-version=>1
		 ,-data=>[$q 
			?('id', $_[0]->{-tn}->{-rvcUpdBy}, $_[0]->{-tn}->{-rvcUpdWhen})
			:({-fld=>'table',			-flg=>'q'}
			 ,{-fld=>'id',				-flg=>'q'}
			 ,{-fld=>$_[0]->{-tn}->{-rvcUpdBy},	-flg=>'ql'}
			 ,{-fld=>$_[0]->{-tn}->{-rvcUpdWhen},	-flg=>'ql'})
			 ,ref($f) eq 'ARRAY' ? @$f : ()]
		 ,-display=>[$_[0]->{-tn}->{-rvcUpdBy}, $_[0]->{-tn}->{-rvcUpdWhen}]
		 ,@o
		 },'; ');
	''
 }
}


sub tvmHistory {	# Template for Materialized View of database History
			# 'history' materialized view default definition
			# self, ? fields, ? definition
	my $s =$_[0]; return($s->{-tn}->{'tvmHistory'}=>
	{-lbl	=>	sub{$_[0]->lng(0,'tvmHistory')}
	,-cmt	=>	sub{$_[0]->lng(1,'tvmHistory')}
	,-field	=>	[
		 {-fld=>$s->{-tn}->{-rvcInsWhen},	-edit=>0, -flg=>'uq'}
		,''
		,{-fld=>$s->{-tn}->{-rvcInsBy},		-edit=>0, -flg=>'uq'}
		,{-fld=>$s->{-tn}->{-rvcUpdWhen},	-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>$s->{-tn}->{-rvcUpdBy},		-edit=>0, -flg=>'uql'}
		#	,{-fld=>'table', -edit=>0, -flg=>'uq'}
		#	,''
		,{-fld=>'id',				-edit=>0, -flg=>'uq'}
		,{-fld=>$s->{-tn}->{-rvcState},		-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>$s->{-tn}->{-rvcActPtr},	-edit=>0, -flg=>'uq'}
		,{-fld=>'subject',			-edit=>0, -flg=>'uql'}
		,{-fld=>'auser',			-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>'arole',			-edit=>0, -flg=>'uql'}
		,{-fld=>'puser',			-edit=>0, -flg=>'uq'}
		,''
		,{-fld=>'prole',			-edit=>0, -flg=>'uq'}
		,{-fld=>'readers',			-edit=>0, -flg=>'u'}
		,{-fld=>'cargo',			-edit=>0, -flg=>'u'}
		,ref($_[1]) eq 'ARRAY' ? @{$_[1]} : ()
		]
	,-key	=>	[$s->{-tn}->{-rvcUpdWhen},$s->{-tn}->{-rvcUpdBy},'id']	# ,'table'
	,-racReader=>	['readers']
	,-racPrincipal=>['puser','prole']
	,-racActor=>	['auser','arole']
	,-rvcInsBy=>	$s->{-tn}->{-rvcInsBy}
	,-rvcUpdBy=>	$s->{-tn}->{-rvcUpdBy}
	,-rvcActPtr=>	$s->{-tn}->{-rvcActPtr}
	,-ixcnd	=>	sub{$_[2]->{'id'} && $_[2]->{$s->{-tn}->{-rvcUpdWhen}}}
	,-ixrec	=>	sub{
		my $m	=$_[0]->{-table}->{$_[1]->{-table}};
		my $ra	= mdeRole($_[0], $m, 'authors');
		my $rp	= mdeRole($_[0], $m, 'principals','users');
		return(
		{'id'		=>$_[1]->{-table} .$RISM1 .$_[2]->{'id'}
		#'table'	=>$_[1]->{-table}
		#'id'		=>$_[2]->{'id'}
		,$_[0]->{-tn}->{-rvcInsWhen}=>$m->{-rvcInsWhen} && $_[2]->{$m->{-rvcInsWhen}}
		,$_[0]->{-tn}->{-rvcInsBy}	 =>$m->{-rvcInsBy}   && $_[2]->{$m->{-rvcInsBy}}
		,$_[0]->{-tn}->{-rvcUpdWhen}=>$m->{-rvcUpdWhen} && $_[2]->{$m->{-rvcUpdWhen}}
		,$_[0]->{-tn}->{-rvcUpdBy}	 =>$m->{-rvcUpdBy}   && $_[2]->{$m->{-rvcUpdBy}}
		,$_[0]->{-tn}->{-rvcState}	 =>$m->{-rvcChgState}&& $_[2]->{$m->{-rvcChgState}->[0]}
		,$_[0]->{-tn}->{-rvcActPtr} =>$m->{-rvcActPtr}  && $_[2]->{$m->{-rvcActPtr}}
		,'subject'	=>join(' '
				,(map {$_[2]->{$_}
					} grep {$_[2]->{$_}
						} qw(record object subject))
				)
		,'auser'	=>(!$ra 		? undef
				: !ref($ra)		? $_[2]->{$ra}
				: @$ra && $ra->[0]	? $_[2]->{$ra->[0]}
				: undef)
				|| $_[2]->{$m->{-rvcUpdBy} ||$_[0]->{-rvcUpdBy} ||''}
		,'arole'	=>!ref($ra) || $#$ra <1
				? undef
				: join(',', map {!$_[2]->{$_} ? () : ($_[2]->{$_})
					} @$ra[1..$#$ra])
		,'puser'	=>(!$rp 		? undef
				: !ref($rp)		? $_[2]->{$rp}
				: @$rp && $rp->[0]	? $_[2]->{$rp->[0]}
				: undef)
				|| $_[2]->{$m->{-rvcInsBy} ||$_[0]->{-rvcInsBy} ||''}
		,'prole'	=>!ref($rp) || $#$rp <1
				? undef
				: join(',', map {!$_[2]->{$_} ? () : ($_[2]->{$_})
					} @$rp[1..$#$rp])
		,'readers'	=>join(',', map {$_[2]->{$_}||''} 
				grep {$_[2]->{$_}} 
				@{$m->{-racReader}||$_[0]->{-racReader}||[]}
				, @{$m->{-racWriter}||$_[0]->{-racWriter}||[]})
		,'cargo'	=>join("\t",map {$_[2]->{$_}||''} 
				grep {$_[2]->{$_}} keys %{$_[2]})
		})}
	,-qhref	=>	{-formfld	=>''	# 'table'
			,-key		=>'id'	# ['id'] # [['id'=>3]]
			}
	,-query	=>	{-order		=>'-dall'}
	,@_ > 2 ? @_[2..$#_] : ()
	})
}



sub tvmReferences {	# Template for Materialized View of References to records
			# 'references' materialized view default definition
			# self, ? fields, ? definition
	my $s =$_[0]; return ($s->{-tn}->{'tvmReferences'}=>
	{-lbl	=>	sub{$_[0]->lng(0,'tvmReferences')}
	,-cmt	=>	sub{$_[0]->lng(1,'tvmReferences')}
	,-field	=>	[
		 {-fld=>'ir',				-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>'id',				-edit=>0, -flg=>'uql'}

		,{-fld=>$s->{-tn}->{-rvcInsWhen},	-edit=>0, -flg=>'uq'}
		,''
		,{-fld=>$s->{-tn}->{-rvcInsBy},		-edit=>0, -flg=>'uq'}
		,{-fld=>$s->{-tn}->{-rvcUpdWhen},	-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>$s->{-tn}->{-rvcUpdBy},		-edit=>0, -flg=>'uq'}

		,{-fld=>$s->{-tn}->{-rvcState},		-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>$s->{-tn}->{-rvcActPtr},	-edit=>0, -flg=>'uq'}
		,{-fld=>'subject',			-edit=>0, -flg=>'uql'}
		,{-fld=>'auser',			-edit=>0, -flg=>'uql'}
		,''
		,{-fld=>'arole',			-edit=>0, -flg=>'uql'}
		,{-fld=>'puser',			-edit=>0, -flg=>'uq'}
		,''
		,{-fld=>'prole',			-edit=>0, -flg=>'uq'}
		,{-fld=>'readers',			-edit=>0, -flg=>'u'}
		,ref($_[1]) eq 'ARRAY' ? @{$_[1]} : ()
		]
	,-key	=>	['ir',$s->{-tn}->{-rvcUpdWhen},'id']
	,-qhrcol=>	1
	,-racReader=>	['readers']
	,-racPrincipal=>['puser','prole']
	,-racActor=>	['auser','arole']
	,-rvcInsBy=>	$s->{-tn}->{-rvcInsBy}
	,-rvcUpdBy=>	$s->{-tn}->{-rvcUpdBy}
	,-rvcActPtr=>	$s->{-tn}->{-rvcActPtr}
	,-ixcnd	=>	sub{$_[2]->{'id'} 
			&& ($_[0]->{-table}->{$_[1]->{-table}}->{-ridRef}
				||$_[0]->{-ridRef})}
	,-ixrec	=>	sub{
		my $s  =$_[0];
		my $m  =$s->{-table}->{$_[1]->{-table}};
		my $ir =[];
		my $id =$_[1]->{-table} .$RISM1 .$_[2]->{'id'};
		foreach my $f (@{$m->{-ridRef} ||$s->{-ridRef}}) {
			if (!$_[2]->{$f}) {
				next
			}
			elsif ($_[2]->{$f} =~/[\s,.?]/) {
				my $v =$_[2]->{$f};
				while ($v =~/(?:_key=id%3D|_key=)([\w\d]+\Q$RISM1\E[\w\d]+)/i) {
					push @$ir, $1;
					$v =$'
				}
			}
			elsif (length($_[2]->{$f}) >$NLEN *3) {
				next
			}
			elsif ($_[2]->{$f} =~/\Q$RISM1\E/) {
				push @$ir, $_[2]->{$f}
			}
			else {
				push @$ir, $_[1]->{-table} .$RISM1 .$_[2]->{$f}
			}
		}
		return($ir) if !@$ir;
		my $ra	= mdeRole($_[0], $m, 'authors');
		my $rp	= mdeRole($_[0], $m, 'principals','users');
		my $rv	=
		{'id'		=>$id
				# below alike 'tvmHistory'
		,$s->{-tn}->{-rvcInsWhen}=>$m->{-rvcInsWhen} && $_[2]->{$m->{-rvcInsWhen}}
		,$s->{-tn}->{-rvcInsBy}  =>$m->{-rvcInsBy}   && $_[2]->{$m->{-rvcInsBy}}
		,$s->{-tn}->{-rvcUpdWhen}=>$m->{-rvcUpdWhen} && $_[2]->{$m->{-rvcUpdWhen}}
		,$s->{-tn}->{-rvcUpdBy}	 =>$m->{-rvcUpdBy}   && $_[2]->{$m->{-rvcUpdBy}}
		,$s->{-tn}->{-rvcState}	 =>$m->{-rvcChgState}&& $_[2]->{$m->{-rvcChgState}->[0]}
		,$s->{-tn}->{-rvcActPtr} =>$m->{-rvcActPtr}  && $_[2]->{$m->{-rvcActPtr}}
		,'subject'	=>join(' '
				,(map {$_[2]->{$_}
					} grep {$_[2]->{$_}
						} qw(record object subject))
				)
		,'auser'	=>(!$ra 		? undef
				: !ref($ra)		? $_[2]->{$ra}
				: @$ra && $ra->[0]	? $_[2]->{$ra->[0]}
				: undef)
				|| $_[2]->{$m->{-rvcUpdBy} ||$_[0]->{-rvcUpdBy} ||''}
		,'arole'	=>!ref($ra) || $#$ra <1
				? undef
				: join(',', map {!$_[2]->{$_} ? () : ($_[2]->{$_})
					} @$ra[1..$#$ra])
		,'puser'	=>(!$rp 		? undef
				: !ref($rp)		? $_[2]->{$rp}
				: @$rp && $rp->[0]	? $_[2]->{$rp->[0]}
				: undef)
				|| $_[2]->{$m->{-rvcInsBy} ||$_[0]->{-rvcInsBy} ||''}
		,'prole'	=>!ref($rp) || $#$rp <1
				? undef
				: join(',', map {!$_[2]->{$_} ? () : ($_[2]->{$_})
					} @$rp[1..$#$rp])
		,'readers'	=>join(',', map {$_[2]->{$_}||''} 
				grep {$_[2]->{$_}} 
				@{$m->{-racReader}||$s->{-racReader}||[]}
				, @{$m->{-racWriter}||$s->{-racWriter}||[]})
		};
		map {$_ ={'ir'=>$_, %$rv}} @$ir;
		$ir}
	,-qhref	=>	{-formfld	=>''
			,-key		=>'id'
			}
	,-query	=>	{-order		=>'-dall'}
	,@_ > 2 ? @_[2..$#_] : ()
	})
}



sub tfvReferences {	# Template for Field embedded View of References to record
 my ($s, $f, @o) =@_;	# (self, ? fields, ? definitions)
 my $v =$s->{-tn}->{'tvmReferences'};
 sub{
	return('') 
		if ($_[0]->{-pcmd}->{-cmg} eq 'recQBF')
		|| !$_[0]->{-pcmd}->{-table}
		|| !$_[0]->{-pout}->{'id'};
	my $q =(($_[0]->{-table}->{$_[0]->{-pcmd}->{-table}}->{-dbd} ||$_[0]->{-dbd}) 
			eq 'dbi')
		&& !$_[0]->{-table}->{$v};
	$v =$_[0]->{-pcmd}->{-table} if $q;
	return('')
		if $q 
		? !$_[0]->{-table}->{$v}->{-ridRef}
		: !$_[0]->{-table}->{$v};
	local $s->{-uiclass} ='tfvReferences';
	local $s->{-uistyle} ='font-size: small' if 0;
	$_[0]->cgiList('-!h'
	,$v
	,undef
	,{-qhrcol=>0, -qflghtml=>$_[0]->cgi->hr()} # .$_[0]->lng(0,'tvmReferences') .': '
	,{-table=>$v
	 ,-version=>0
	 , $q
	 ?(-where=>join(' OR '
			, map { $v .'.' .$_ .'=' .$_[0]->{-dbi}->quote($_[0]->{-pout}->{'id'})
				} @{$_[0]->{-table}->{$v}->{-ridRef}}
			)
	  ,-order=>[[$_[0]->{-tn}->{-rvcUpdWhen}=>'desc']]
		)
	 :(-field=>[{-fld=>'ir',			-flg=>'q'}
		 ,{-fld=>'id',				-flg=>'q'}
		 ,{-fld=>$_[0]->{-tn}->{-rvcUpdWhen},	-flg=>'ql'}
		 ,{-fld=>$_[0]->{-tn}->{-rvcState},	-flg=>'ql'}
		 ,{-fld=>'subject',			-flg=>'ql'}
		 ,{-fld=>'auser',			-flg=>'ql'}
		 ,{-fld=>'arole',			-flg=>'ql'}
		,ref($f) eq 'ARRAY' ? @$f : ()
		]
	  ,-key=>{'ir'=>$_[0]->{-pcmd}->{-table} .$RISM1 .$_[0]->{-pout}->{'id'}}
	  ,-order=>'-deq'
		)
	,@o
	});
	''
 }
}



sub tvdIndex {	# Template View Definition for Index page
 my $s =$_[0]; return ($s->{-tn}->{'tvdIndex'}=>
 {-lbl		=>sub{$_[0]->lng(0,'tvdIndex')}
 ,-cmt		=>sub{$_[0]->lng(1,'tvdIndex')}
 ,-cgcCall	=>sub{
	my $s =$_[0];
	$s->{-fetched}	=undef;
	$s->{-affected}	=undef;
	local @{$s}{-menuchs, -menuchs1} =@{$s}{-menuchs, -menuchs1};
	$s->htmlMChs()	if !$s->{-menuchs};
	$s->output($s->htmlStart(@_[1,2])	# HTTP/HTML/Form headers
		,$s->htmlHidden(@_[1,2])	# common hidden fields
		,!$s->{-pcmd}->{-print}
		&& $s->htmlMenu(@_[1,2])	# Menu bar
		,"\n<table class=\"ListTable\">\n"
		);
	foreach my $e	(($s->{-menuchs} ? @{$s->{-menuchs}} : ())
			,($s->{-menuchs1}? @{$s->{-menuchs1}}: ())
			) {
		my ($n, $l) = ref($e) ? @$e : ($e, $e);
		my ($o, $a) = $n =~/^(.+?)([+&.]+)$/ ? ($1, $2) : ($n, $n);
		my $l0 =$s->lnglbl($s->{-form}->{$o} ||$s->{-table}->{$o} ||{}, $o)||'';
		my $l1 =$s->lngcmt($s->{-form}->{$o} ||$s->{-table}->{$o} ||{}, $o)||'';
		$s->output('<tr><th align="left" valign="top">'
			, $n
			? $s->cgi->a({-href=>$s->urlCat('','_form'=>$n,'_cmd'=>'frmCall')
				,-title=>  $a =~/[+]/ 
					? $s->lng(1,'frmCallNew') ." '$l0'"
					: $a =~/[&.]/
					? $s->lng(0,'frmCallOpn') ." '$l0'"
					: $s->lng(0,'frmCallOpn') ." '$l0'"
				}
				,(!$s->{-icons}
				? ''
				: '<img border="0" src="' .$s->{-icons} .'/'
				. ( $a =~/[+]/  ? $IMG->{'recNew'}
				  : $a =~/[&.]/ ? $IMG->{'frmCall'}
				  : $IMG->{'recList'}
				  ) .'" />')
				. $s->htmlEscape($l0))
			: $s->htmlEscape($l)
			, "</th>\n"
			, '<td>&nbsp;</td><td align="left" valign="bottom">'
			, $s->htmlEscape( !$l1 || $l1 ne $l0
					? $l1||''
					: 1
					? $l1||''
					: $a =~/[+]/ 
					? $s->lng(0,'frmCallNew') ." '$l0'"
					: $a =~/[&.]/
					? $s->lng(0,'frmCallOpn') ." '$l0'"
					: $s->lng(0,'frmCallOpn') ." '$l0'"
					)
			, "</td></tr>\n"
			)
		}
	$s->output("\n</table>\n");
	# $s->recCommit();
	$s->cgiFooter() if !$s->{-pcmd}->{-print};
	$s->htmlEnd();
	$s->end();
	}
	,@_ > 1 ? @_[1..$#_] : ()
 })
}



sub tvdFTQuery {	# Template View Definition for Full-Text Query
 my $s =$_[0]; return ($s->{-tn}->{'tvdFTQuery'}=>
 {-lbl		=>sub{$_[0]->lng(0,'tvdFTQuery')}
 ,-cmt		=>sub{$_[0]->lng(1,'tvdFTQuery')}
 ,-cgcCall	=>sub{
	my $s =$_[0];
	my $g =$s->cgi();
	$s->{-fetched}	=0;
	$s->{-affected}	=undef;
	$s->{-pcmd}->{-cmd} =$s->{-pcmd}->{-cmg} ='recQBF';
	$s->output($s->htmlStart(@_[1,2])	# HTTP/HTML/Form headers
		,$s->htmlHidden(@_[1,2])	# common hidden fields
		,!$s->{-pcmd}->{-print}
		&& $s->htmlMenu(@_[1,2])	# Menu bar
		,"\n"
		);
	$s->die('Microsoft IIS required')	if $ENV{SERVER_SOFTWARE} !~/IIS/;
	$g->param('_qftwhere'
		, defined($g->param('_qftwhere')) && ($g->param('_qftwhere') ne '')
		? $g->param('_qftwhere')
		: defined($g->param('_qftext')) && ($g->param('_qftext') ne '')
		? $g->param('_qftext')
		: '');
	$s->output($g->textfield(-name=>'_qftwhere', -size=>70, -title=>$s->lng(1,'-qftwhere'))
		, '<br />'
		, $g->popup_menu(-name=>'_qftord'
			,-values=>['write','hitcount','vpath','docauthor']
			,-labels=>{
				 'write'	=>'Chronologically'
				,'hitcount'	=>'Ranked'
				,'vpath'	=>'by Name'
				,'docauthor'	=>'by Author'
				}
			,-default=>'write')
		, $g->popup_menu(-name=>'_qlimit'
			,-values=>['',128,256,512,1024,2048,4096]
			,-labels=>{
				 ''  =>"$LIMRS default"
				,128 =>'128  max'
				,256 =>'256  max'
				,512 =>'512  max'
				,1024=>'1024 max'
				,2048=>'2048 max'
				,4096=>'4096 max'
				}
			,-default=>$LIMRS)
		, $g->submit(-name =>'tvdFTQuery_'
			,-value=>$s->lng(0,'recList')
			,-title=>$s->lng(1,'recList'))
		, '' && $g->a({-href=>
			-e ($ENV{windir} .'/help/ix/htm/ixqrylan.htm')
			? '/help/microsoft/windows/ix/htm/ixqrylan.htm'
			: '/help/microsoft/windows/isconcepts.chm' # .'::/ismain-concepts_30.htm'
			}, '?')
		, "<br />\n");

	if ($g->param('_qftwhere') ne '') {
		eval('use Win32::OLE; Win32::OLE->Option("Warn"=>0)');
		Win32::OLE->Initialize();
		# Win32::OLE->Initialize(&Win32::OLE::COINIT_OLEINITIALIZE);
		# Search MSDN for 'ixsso.Query'
		my $oq =Win32::OLE->CreateObject("ixsso.Query");
		!$oq && $s->die("'OLE->CreateObject(ixsso.Query)' failed '$!'/'$@'/" .Win32::OLE->LastError);
		my $ou =Win32::OLE->CreateObject("ixsso.util");
		!$oq && $s->die("'OLE->CreateObject(ixsso.util)' failed '$!'/'$@'/" .Win32::OLE->LastError);
		my $qs =[];
		my $qt =[];
		$oq->{Query} =$g->param('_qftwhere') =~/^(@\w|\{\s*prop\s+name\s+=)/i
				? $g->param('_qftwhere')
				: ('@contents ' .$g->param('_qftwhere'));
		$oq->{Catalog}    ='Web';
		$oq->{MaxRecords} =$g->param('_qlimit') ||$LIMRS;
		$oq->{MaxRecords} =4096 if $oq->{MaxRecords} >4096;
		$oq->{SortBy}     =$g->param('_qftord') ||'write';
		$oq->{SortBy}    .=$oq->{SortBy} =~/^(write|hitcount)$/i 
				? '[d],docauthor[a]' 
				: '[a],write[d]';
		$oq->{Columns}    ='vpath,path,filename,hitcount,write,doctitle,docauthor,characterization';
		$oq->{LocaleID}   =1049; # ru

		my $ol =eval {$oq->CreateRecordset('sequential')}; # 'nonsequential'
		!$oq && $s->die("'OLE->CreateRecordset(sequential)' failed '$!'/'$@'/" .Win32::OLE->LastError);
		$s->output('No records found') if $ol->{EOF};

		my ($rcf, $rct, $rcd) =(0, 0, 0);
		while (!$ol->{EOF}) {
			my $vp =$ol->{vPath}->{Value};
			$rcf +=1;
			if (!$vp) {
				$rct +=1;
			}
			if ($vp) {
				$rcd +=1;
				my $vt =$g->escapeHTML($ol->{DocTitle}->{Value});
				$vt = ($vt ? '$vt' .'&nbsp;&nbsp;' : '')
				. '(' .$g->escapeHTML($ol->{DocAuthor}->{Value}) .')'
					if $ol->{DocAuthor}->{Value};
				$vt = ($vt ? $vt .'&nbsp;&nbsp;&nbsp;(' : '')
					. $g->escapeHTML($vp) .')';
				$s->output($g->a({-href=>$vp||$ol->{Path}->{Value}
						,-title=>$ol->{HitCount}->{Value}
						.': ' .$ol->{Path}->{Value}}
						, $vt)
					, $ol->{Characterization}->{Value}
					? '<br />' .$g->escapeHTML($ol->{Characterization}->{Value})
					: ''
					, "<br /><br />\n");
			}
			if (!eval {$ol->MoveNext; 1}) {
				$s->output('Bad query');
				last
			}
		}
		Win32::OLE->FreeUnusedLibraries;
		# Win32::OLE->Uninitialize;
		$s->{-fetched}	=$rcd;
		$s->{-affected}	=$rcf;
		$s->logRec('FTQuery',-fetched=>$rcd, -found=>$rcf, -vpathgen=>$rct, -max=>($oq->{MaxRecords}||'undef'));
	}
	else  {
		$s->output('Enter query condition')
	}
	$s->{-pcmd}->{-cmd} =$s->{-pcmd}->{-cmg} ='recList';
	$s->cgiFooter() if !$s->{-pcmd}->{-print};
	$s->htmlEnd();
	$s->end();
 }
 ,@_ > 1 ? @_[1..$#_] : ()})
}


sub ttsAll {	# Template Tables Set of All generally used views
 return(	# - to add to '-table'
	 $_[0]->tvmVersions()
	,$_[0]->tvmHistory()
	,$_[0]->tvmReferences()
 )
}


sub tfsAll {	# Template Fields Set for All generally used fields
 return(	# - to add to '-field'
	 $_[0]->tfdRFD()
	,$_[0]->tfvVersions()
	,$_[0]->tfvReferences()
 )
}


#########################################################
# File Handle Object
#########################################################



package DBIx::Web::FileHandle;
use strict;
use Symbol;
use Fcntl qw(:DEFAULT :flock :seek :mode);

sub new {
  my ($c, %o) =@_;
  my $s ={-name  =>''       # file name
         ,-mode  =>'<'      # file open mode
         ,-parent=>undef    # parent object
         ,-handle=>undef    # Symbol::gensym on file open
         ,-lock  =>LOCK_UN  # lock level
         ,-lcks  =>{}       # locks
       # ,-new   =>undef    # new file created
       # ,-buf   =>undef    # file contents from 'loadXX' calls
       # ,-ret   =>undef    # data to return, for external programming
         };
  foreach my $k (keys(%o)) {$s->{$k} =$o{$k}}
  bless $s, $c;
  $s->open() if defined($s->{-name}) && $s->{-name} ne '';
  $s
}


sub set {
 return(keys(%{$_[0]})) if scalar(@_) ==1;
 return($_[0]->{$_[1]}) if scalar(@_) ==2;
 my ($s, %o) =@_;
 foreach my $k (keys(%o)) {$s->{$k} =$o{$k}};
 $s
}


sub parent {
 $_[0]->{-parent}
}


sub open {
 my $s =shift;
 if    (!@_) {}
 elsif ($_[0] =~/^-(name|mode)$/) {$s->set(@_)}
 else  {foreach my $k ('-mode','-name') {$s->{$k} =shift if defined($_[0])}}
 $s->{-new} =!-e $s->{-name};
 $s->{-lcks}={};
 if (!CORE::open($s->{-handle} =Symbol::gensym, $s->{-mode}, $s->{-name})) {
    $s->{-handle} =undef;
    return(&{$s->{-parent} ? $s->{-parent}->{-die} : \&die}
           ("File: open('" .($s->{-mode}||'') ."','" .($s->{-name}||'') ."') -> $!") ||undef)
 }
 $s
}


sub opent {
 return($_[0]) if $_[0]->{-handle};
 $_[0]->open() || return(undef);
 $_[0]->lock($_[0]->{-lock}) if $_[0]->{-lock} ne LOCK_UN;
 $_[0]
}


sub binmode {
 CORE::binmode($_[0]->{-handle}); $_[0]
}

sub close {
 return($_[0]) if !$_[0]->{-handle};
 $_[0]->lock(LOCK_UN) if $_[0]->{-lock} ne LOCK_UN;
 $_[0]->{-lcks}={};
 CORE::close($_[0]->{-handle}); 
 $_[0]->{-handle} =undef;
 $_[0]
}


sub destroy {
 eval{$_[0]->close()} if $_[0]->{-handle};
 $_[0]->{-parent} =undef;
 $_[0]
}


sub DESTROY {
 destroy(@_)
}


sub lock  { # ?lock value, ?lock key
 # LOCK_SH ==1; LOCK_EX ==2, or LOCK_UN ==8, LOCK_NB ==4 
 return($_[0]->{-lock}) if !defined($_[1]);
 my $l =!$_[1] ? LOCK_UN : $_[1];
 my $lv=$l | LOCK_NB ^ LOCK_NB;
 $_[0]->opent() if !$_[0]->{-handle};
 if ($_[0]->{-lock} ne $lv) {
    if ($lv eq LOCK_UN) {
       CORE::flock($_[0]->{-handle}, $_[0]->{-lock} =LOCK_UN);
       if (!defined($_[2])) { $_[0]->{-lcks} ={} }
       else                 { delete $_[0]->{-lcks}->{$_[2]} }
       $l =0; map {$l =$_ if $l <$_} values %{$_[0]->{-lcks}};
       $_[0]->{-lock} =$lv =$l if $l && CORE::flock($_[0]->{-handle}, $l);
    }
    else {
       CORE::flock($_[0]->{-handle}, $_[0]->{-lock} =LOCK_UN);
       $_[0]->{-lock} =$lv if CORE::flock($_[0]->{-handle}, $l);
    }
 }
 if    (!defined($_[2]))	{ $_[0]->{-lcks} ={} }
 elsif ($lv eq LOCK_UN
    ||  $_[0]->{-lock} ne $lv )	{ delete $_[0]->{-lcks}->{$_[2]} }
 else				{ $_[0]->{-lcks}->{$_[2]} =$lv }
 $_[0]->{-lock} eq $lv ? $_[0] : undef
}


sub seek {
  # WHENCE: 0 - SEEK_SET - to set the new position to POSITION, 
  #         1 - SEEK_CUR - to set it to the current position plus POSITION, 
  #         2 - SEEK_END - to set it to EOF plus POSITION 
  return(CORE::tell($_[0]->{-handle})) if @_ <2;
  CORE::seek($_[0]->{-handle}, $_[1], defined($_[2]) ?$_[2] :SEEK_SET) 
   ? $_[0] 
   : (&{$_[0]->{-parent} ? $_[0]->{-parent}->{-die} : \&die}
      ("File: seek('" .($_[0]->{-name}||'') ."') -> $!") ||undef)
}


sub read {
 my $r =CORE::read($_[0]->{-handle}, $_[1], $_[2], $_[3]||0);
 return(&{$_[0]->{-parent} ? $_[0]->{-parent}->{-die} : \&die}
        ("File: read('" .($_[0]->{-name}||'') ."') -> $!") ||undef)
     if !defined($r);
 $r
}


sub readline {
 CORE::readline($_[0]->{-handle})
}


sub print {
 my $s =shift;
 my $h =$s->{-handle};
 return(&{$s->{-parent} ? $s->{-parent}->{-die} : \&die}
        ("File: print('" .($s->{-name}||'') ."') -> $!") ||undef)
     if !CORE::print $h @_;
 $s
}

sub load {
 my $b ='';
 my $l =$_[0]->{-lock};
 $_[0]->opent() if !$_[0]->{-handle};
 $_[0]->lock(LOCK_SH) if $l eq LOCK_UN;
 $_[0]->{-buf} =defined($_[0]->seek(0)->read($b, -s $_[0]->{-handle})) ? $b : undef;
 $_[0]->lock(LOCK_UN) if $l eq LOCK_UN;
 defined($_[0]->{-buf}) ? $_[0] : undef;
}


sub store {
 my $s =shift;
 my $l =$s->{-lock};
 $s->opent() if !$s->{-handle};
 $s->lock(LOCK_EX) if $l eq LOCK_UN;
 truncate($s->{-handle}, 0);
 my $r =$s->seek(0)->print(@_ ? @_ : $s->{-buf});
 $s->lock(LOCK_UN) if $l eq LOCK_UN;
 $r
}


sub select {
 my $r;
 ref($_[1]) eq 'CODE'
 ? select((select($_[0]->{-handle}), $r =&{$_[1]}(@_))[0]) && $r
 : select($_[0]->{-handle})
}



#########################################################
# DB_File ISAM Handle Object
#########################################################



package DBIx::Web::dbmHandle;
use strict;
use Symbol;
use Fcntl qw(:DEFAULT :flock :seek :mode);

# my	$NLEN	=20;		# length to pad left index numbers

sub new {
  my ($c, %o) =@_;
  my $s ={-name  =>''		# file name
	 ,-mode  =>O_CREAT|O_RDWR
	 ,-parent=>undef	# parent object
	#,-table =>undef	# data table description
	 ,-handle=>undef	# tied object ref
	#,-data  =>undef	# tied data hash ref
	#,-new   =>undef	# new file created
	#,-fh    =>undef	# file handle
	 ,-lock  =>LOCK_UN	# lock level
	 ,-lcks  =>{}		# locks
	 ,-pair  =>[]		# current key/value
         };
  foreach my $k (keys(%o)) {$s->{$k} =$o{$k}}
  bless $s, $c;
  $s->open if defined($s->{-name}) && $s->{-name} ne '';
  $s
}


sub set {
 return(keys(%{$_[0]})) if scalar(@_) ==1;
 return($_[0]->{$_[1]}) if scalar(@_) ==2;
 my ($s, %o) =@_;
 foreach my $k (keys(%o)) {$s->{$k} =$o{$k}};
 $s
}


sub parent {
 $_[0]->{-parent}
}


sub open {
 eval('use DB_File');
 my $s =shift;
 if    (!@_) {}
 elsif ($_[0] =~/^-(name|mode)$/) {$s->set(@_)}
 else  {foreach my $k ('-mode','-name') {$s->{$k} =shift if defined($_[0])}}

 my %hash;
 my $par =eval('new DB_File::BTREEINFO');
 if ($s->{-table} && $s->{-table}->{-keycmp}) {
    my $t =$s->{-table}->{-keycmp};
    $par->{'compare'} =sub{&t($s, map {[map {m/^ *(.*)$/ ? $1 : $_} split /\x00/, $_]} @_)}
                                  # see keyUnescape below
 }
 $s->{-new}    =!-e $s->{-name};
 $s->{-handle} =tie %hash, 'DB_File', $s->{-name}, $s->{-mode}, 0x666, $par;
 $s->{-data}   =\%hash;
 $s->{-lcks}   ={};

 if (!$s->{-handle}) {
    $s->{-handle} =$s->{-data} =undef;
    return(&{$s->{-parent} ? $s->{-parent}->{-die} : \&die}
           ("DBFile: open('" .($s->{-mode}||'') ."','" .($s->{-name}||'') ."') -> $!") ||undef)
 }
 $s
}


sub opent {
 return($_[0]) if $_[0]->{-handle};
 $_[0]->open || return(undef);
 $_[0]->lock($_[0]->{-lock}) if $_[0]->{-lock} ne LOCK_UN;
 $_[0]
}


sub close {
 return($_[0]) if !$_[0]->{-handle};
 $_[0]->lock(LOCK_UN) if $_[0]->{-lock} ne LOCK_UN;
 close($_[0]->{-fh})  if $_[0]->{-fh};
 my $h =$_[0]->{-data};
 $_[0]->{-data}   =undef;
 $_[0]->{-handle} =undef;
 $_[0]->{-fh}     =undef;
 $_[0]->{-lcks}   ={};
#eval {untie %$h}; # warning if another reference exists
 $_[0]
}


sub destroy {
 eval{$_[0]->close} if $_[0]->{-handle};
 $_[0]->{-parent} =undef;
 $_[0]->{-table}  =undef;
 $_[0]
}


sub DESTROY {
 destroy(@_)
}


sub lock  { # lock value, ?lock key
 # LOCK_SH ==1; LOCK_EX ==2, or LOCK_UN ==8, LOCK_NB ==4 
 return($_[0]->{-lock}) if !defined($_[1]);
 my $l =!$_[1] ? LOCK_UN : $_[1];
 my $lv=$l | LOCK_NB ^ LOCK_NB;
 if (!$_[0]->{-fh} && !CORE::open($_[0]->{-fh} =Symbol::gensym, '+<&=' .$_[0]->{-handle}->fd)) {
    $_[0]->{-fh} =undef;
    return(&{$_[0]->{-parent} ? $_[0]->{-parent}->{-die} : \&die}
           ("DBFile: open('+<&=','" .($_[0]->{-name}||'') ."') -> $!") ||undef)
 }
 if ($_[0]->{-lock} ne $lv) {
    $_[0]->{-handle}->sync;
    if ($lv eq LOCK_UN) {
       CORE::flock($_[0]->{-fh}, $_[0]->{-lock} =LOCK_UN);
       if (!defined($_[2])) { $_[0]->{-lcks} ={} }
       else                 { delete $_[0]->{-lcks}->{$_[2]} }
       $l =0; map {$l =$_ if $l <$_} values %{$_[0]->{-lcks}};
       $_[0]->{-lock} =$lv =$l if $l && CORE::flock($_[0]->{-fh}, $l);
    }
    else {
       CORE::flock($_[0]->{-fh}, $_[0]->{-lock} =LOCK_UN);
       $_[0]->{-lock} =$lv if CORE::flock($_[0]->{-fh}, $l);
    }
    $_[0]->{-handle}->sync;
 }
 if    (!defined($_[2]))	{ $_[0]->{-lcks} ={} }
 elsif ($lv eq LOCK_UN
    ||  $_[0]->{-lock} ne $lv )	{ delete $_[0]->{-lcks}->{$_[2]} }
 else				{ $_[0]->{-lcks}->{$_[2]} =$lv }
 $_[0]->{-lock} eq $lv ? $_[0] : undef
}



sub keyGet {
 return($_[0]->{-pair}->[1]) if @_ <2;
 my $v; $_[0]->{-handle}->get($_[1], $v) ? undef : $v
}


sub keyPut {
 $_[0]->{-handle}->put($_[1], $_[$#_])
 ? (&{$_[0]->{-parent} ? $_[0]->{-parent}->{-die} : \&die}
    ("DBFile: keyPut('" .($_[0]->{-name}||'') ."','" .$_[1] ."') -> $!") ||undef)
 : (@_ >3) && ($_[1] ne $_[2]) && $_[0]->{-handle}->del($_[2])
 ? (&{$_[0]->{-parent} ? $_[0]->{-parent}->{-die} : \&die}
    ("DBFile: keyDel('" .($_[0]->{-name}||'') ."','" .$_[2] ."') -> $!") ||undef)
 : $_[$#_]
}


sub keyDel {
 $_[0]->{-handle}->del(@_[1..$#_]) ? undef : $_[0]
}


sub keyFind {
 my ($s, $k, $v) =@_; 
 $s->{-handle}->seq($k, $v, R_CURSOR()) ? undef : (@{$s->{-pair}}[1,0]=($k,$v))[0]
}


sub keyFirst {
 my ($s, $k, $v) =@_; 
 $s->{-handle}->seq($k, $v, R_FIRST())  ? undef : (@{$s->{-pair}}[1,0]=($k,$v))[0]
}


sub keyLast {
 my ($s, $k, $v) =@_;
 $s->{-handle}->seq($k, $v, R_LAST())   ? undef : (@{$s->{-pair}}[1,0]=($k,$v))[0]
}


sub keyPrev {
 my ($s, $k, $v) =@_;
 $s->{-handle}->seq($k, $v, R_PREV())   ? undef : (@{$s->{-pair}}[1,0]=($k,$v))[0]
}


sub keyNext {
 my ($s, $k, $v) =@_;
 $s->{-handle}->seq($k, $v, R_NEXT())   ? undef : (@{$s->{-pair}}[1,0]=($k,$v))[0]
}


sub krEscape {
 join "\x00"
 ,map {	my $v =$_; 
	return('') if !defined($v);		# !!! lost undefined values
	$v =~s/^ *(.*?) *$/$1/;			# !!! lost extra blanks
      # $v =~s/\000/\\000/g;			# !!! key compare problem
	$v =~s/\000//g;				# !!! lost \x00 chars
	$v =' ' x ($NLEN -length($v)) .$v 	# !!! $NLEN-sign numbers
	   if $v =~/^[\d .,]+$/m && length($v) <$NLEN;
	$v
      } @{$_[1]}
}


sub krEscapeMv {
 my $r =[''];
 foreach my $v (@{$_[1]}) {
   if    (!ref($v)) {
       $v ='' if !defined($v);			# !!! lost undefined values
       $v =~s/^ *(.*?) *$/$1/;			# !!! lost extra blanks
       $v =~s/\000//g;				# !!! lost \x00 chars
       $v =' ' x ($NLEN -length($v)) .$v	# !!! $NLEN-sign numbers
          if $v =~/^[\d .,]+$/m && length($v) <$NLEN;
       map {$_ .=$v ."\x00"} @$r
   }
   elsif (ref($v) eq 'ARRAY') {
     my $r0 =$r; $r =[];
     my $a  =$v;
     foreach my $k (@$a) {
       foreach my $e (@{krEscapeMv($_[0],$k)}) {
         foreach my $v (@$r0) { push @$r, "$v$e\x00" }
       }
     }
   }
   elsif (ref($v) eq 'HASH') {
     my $r0 =$r; $r =[];
     my $h  =$v;
     foreach my $k (keys %$h) {
       my $v =$k;
       $v ='' if !defined($v);		# !!! lost undefined values
       $v =~s/^ *(.*?) *$/$1/;		# !!! lost extra blanks
       $v =~s/\000//g;			# !!! lost \x00 chars
       foreach my $e (@{krEscapeMv($_[0], $h->{$k})}) {
         foreach my $v (@$r0) { push @$r, $v . "$k=>$e\x00" }
       }
     }
   }
 }
 map {chop $_} @$r;
 $r
}


sub krUnescape {
	[map {m/^ *(.*)$/ ? $1 : $_} split /\x00/, $_[$#_]]
}


sub klUnescape {
	map {m/^ *(.*)$/ ? $1 : $_} split /\x00/, $_[$#_]
}


sub hrEscape {		# freeze($_[$#_])
	ref($_[$#_]) ne 'ARRAY'
	? '{' .join(','
		, map {	my ($k, $v) =($_, $_[$#_]->{$_});
			$k =~s/([,=%\\\]\[\{\}])/sprintf("\\x%02x",ord($1))/eg;
			if	(ref($v)) {$v =hrEscape($v)}
			else	{$v =~s/([,=%\\\]\[\{\}])/sprintf("\\x%02x",ord($1))/eg}
			"$k=$v"
			} grep {defined($_[$#_]->{$_})
				} keys %{$_[$#_]}) .'}'
	: '[' .join(','
		, map {	my $k =$_;
			$k =~s/([,=%\\\]\[\{\}])/sprintf("\\x%02x",ord($1))/eg;
			$k
			} grep {defined($_)
				} @{$_[$#_]}) .']'
}

sub hrUnescape {	# thaw($_[$#_])
	$_[$#_] =~/^\{/ ? {hlUnescape(@_)} : $_[$#_] =~/^\[/ ? [hlUnescape(@_)] : $_[$#_]
}

sub hlUnescape {	# %{thaw($_[$#_])}
 if (ref($_[$#_])) {
	my $k;
	while ($k =each %{$_[$#_]}) {$_[$#_]->{$k} =undef};
	$k =undef;
	foreach (split / *[,=] */, ($_[$#_-1] =~/^[\{\[]/ ? substr($_[$#_-1], 1, -1) : $_[$#_-1])) {
			/^\[\{\[]/
			? hrUnescape($_[0], $_)
			: s/\\x([0-9a-fA-F]{2})/chr hex($1)/eg;
		if ($k)	{$_[$#_]->{$k} =$_; $k =undef}
		else	{$k =$_}
	}
	$_[$#_];
 }
 else {	
	$_[$#_] =~/^[\{\[]/
	? (map {	/^\[\{\[]/
			? hrUnescape($_[0], $_)
			: s/\\x([0-9a-fA-F]{2})/chr hex($1)/eg;
		} split / *[,=] */, substr($_[$#_], 1, -1))
	: ($_[$#_])
 }	
}


sub keGet {
 return($_[0]->{-pair}->[1]) if @_ <2;
 my $v; $_[0]->{-handle}->get(krEscape($_[0], $_[1]), $v) ? undef : hrUnescape($v)
}


sub kePut {
 my $r =0;
 my $d =hrEscape($_[$#_]);
 if (@_ >3) {
	my $kn =krEscapeMv($_[0], $_[1]);
	my $ko =krEscapeMv($_[0], $_[2]);
	foreach my $k (@$kn) {
		$_[0]->{-handle}->put($k, $d)
		&& (&{$_[0]->{-parent} ? $_[0]->{-parent}->{-die} : \&die}
		("DBFile: kePut('" .($_[0]->{-name}||'') ."','$k') -> '$!'") ||undef);
		$r +=1;
	}
	foreach my $k (grep {my $v =$_; !grep {$v eq $_} @$kn} @$ko) {
		$_[0]->{-handle}->del($k)
	}
 }
 else {
	foreach my $k (@{krEscapeMv($_[0], $_[1])}) {
		$_[0]->{-handle}->put($k, $d)
		&& (&{$_[0]->{-parent} ? $_[0]->{-parent}->{-die} : \&die}
		("DBFile: kePut('" .($_[0]->{-name}||'') ."','$k') -> '$!'") ||undef);
		$r +=1;
	}
 }
 $r
}


sub keDel {
 my $r =0;
 foreach my $k (@{krEscapeMv($_[0], $_[1])}) {
    $_[0]->{-handle}->del($k) ||($r +=1)
 }
 $r ||undef
}



sub keSeek {
 my ($s, $flg, $sca, $subf, $subw) =@_;
    # dir/cmp, keyArray, subFilter, subEval
 my $p   =$s->parent;
 my $val =undef;
 my $dbh =$s->{-handle};
 my $dbs =0;
 my @kds =map {!ref($_) ? $_ : $_->[0]} @{$s->{-table}->{-key}} # , '_rid'
          if $s->{-table} && $s->{-table}->{-key};
 my ($r, $k) =({}, []); # record hash & key array refs
 my $ca  =0;
 my $subr=sub{undef};

 foreach my $sck (@{$s->krEscapeMv($sca)}) {
   my $key =$sck;
   my $scl =length($sck);
   if    ($flg =~/^-*[af]eq/i)    { # forward  eq
         $dbs =$dbh->seq($key, $val, R_CURSOR());
         $subr=sub{do {	return(undef) unless !$dbs && (defined($key) ? $sck eq substr($key, 0, $scl) : 0);
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_NEXT());
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
   elsif ($flg =~/^-*[af]g[te]/i) { # forward  g[te]
         $key .="\x01" if $flg =~/gt$/i;
	 $dbs =$dbh->seq($key, $val, R_CURSOR());
         $subr=sub{do {	return(undef) unless !$dbs;
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_NEXT());
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
   elsif ($flg =~/^-*[af]l[te]/i) { # forward  l[te]
	 $dbs =$dbh->seq($key, $val, R_FIRST());
         $subr=sub{do {	return(undef) unless !$dbs
			&& (!defined($key) ? 0 
  			   :  $flg=~/lt$/i ? $sck lt substr($key, 0, $scl) 
  					   : $sck le substr($key, 0, $scl));
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_NEXT());
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
   elsif ($flg =~/^-*[af]all/i) {   # forward  all
	 $dbs =$dbh->seq($key, $val, R_FIRST());
         $subr=sub{do {	return(undef) unless !$dbs;
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_NEXT());
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
   elsif ($flg =~/^-*[bd]eq/i)    { # backward eq
         $key .="\x01";
         $dbs =$dbh->seq($key, $val, R_CURSOR());
	 $dbs =$dbh->seq($key, $val, R_PREV());
         $subr=sub{do {	return(undef) unless !$dbs
			&& (defined($key) ? $sck eq substr($key, 0, $scl) : 0);
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_PREV())
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
   elsif ($flg =~/^-*[bd]l[te]/i) { # backward l[te]
         $key .="\x01" if $flg =~/le$/i;
         $dbs =$dbh->seq($key, $val, R_CURSOR());
	 $dbs =$dbh->seq($key, $val, R_PREV());
         $subr=sub{do {	return(undef) unless !$dbs;
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_PREV())
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
   elsif ($flg =~/^-*[bd]g[te]/i) { # backward g[te]
	 $dbs =$dbh->seq($key, $val, R_LAST());
         $subr=sub{do {	return(undef) unless !$dbs
			&& (!defined($key) ? 0 
  			   :  $flg=~/gt$/i ? $sck gt substr($key, 0, $scl) 
  					   : $sck ge substr($key, 0, $scl));
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_PREV())
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
   elsif ($flg =~/^-*[bd]all/i) {   # backward all
	 $dbs =$dbh->seq($key, $val, R_LAST());
         $subr=sub{do {	return(undef) unless !$dbs;
			$r =hlUnescape($s, $val, $r);
			@$k=klUnescape($s, $key);
			@$r{@kds}=@{$k} if @kds && !@$r{@kds};
			$dbs     =$dbh->seq($key, $val, R_PREV())
		} while  ($subf && !&$subf($s, $k, $r))
		     ||  ($subw && ++$ca && &$subw($s, $k, $r));
	  	$r }
   }
 }
 $subr =DBIx::Web::dbmCursor->new($subr, -rec=>$r, -key=>$k);
 if ($subw) {$subr->call; $subr =$ca};
 $subr
}


sub keScan {
 &{shift->parent->{-die}}("DBFile: 'keScan' not implemented yet!")
}



#########################################################
# Condition code block object, use isa($object,'CODE') !
#########################################################


package DBIx::Web::ccbHandle;
use strict;

sub new {
  my ($c, $e) =@_;
  if (!ref($e)) { # string to safe evaluate
     my $c =$e;
     my $m =eval('use Safe; Safe->new()');
     #  $m->permit_only(qw(recSel recRead fetch fetchrow_arrayref fetchrow_hashref :default)); # may be :base_core :browse
	$m->permit_only(qw(:default :base_core :browse));
        $m->share('@_', '$DBIx::Web::SELF');
     my $o =$DBIx::Web::SELF;
     $e =sub{	local ($DBIx::Web::SELF, $^W) =($o, undef);
		$m->reval($c)};
  }
  bless $e, $c;
  $e
}


sub call { &{$_[0]}(@_[1..$#_]) }

sub fetch{ &{$_[0]}(@_[1..$#_]) }

sub eval { CORE::eval{&{$_[0]}(@_[1..$#_])} }



#########################################################
# DBM Cursor object
#########################################################


package DBIx::Web::dbmCursor;
use strict;

sub new {
  my ($c, $e) =@_;
  my $s={''=>$e, -rfl=>undef, @_[2..$#_]};
	# -rec=>{}, -key=>[], -rfr=>[]; -query=>{}
  bless $s, $c;
  $s
}

sub setcols {
 $_[0]->{NAME_db} =[map {!ref($_) ? $_ : ref($_) ne 'HASH' ? $_->[0] : (defined($_->{-expr}) ? $_->{-expr} : $_->{-fld})} ref($_[1]) ? @{$_[1]} : @_[1..$#_]];
 $_[0]->{NAME}	  =[map {!ref($_) ? $_ : ref($_) ne 'HASH' ? $_->[1] : $_->{-fld}} ref($_[1]) ? @{$_[1]} : @_[1..$#_]];
 $_[0]->{-rfr}	  =[map {$_[0]->{-rec}->{$_} =undef if !exists($_[0]->{-rec}->{$_});
			 \($_[0]->{-rec}->{$_})
			} @{$_[0]->{NAME_db}}] if $_[0]->{-rec};
 $_[0]->{-rfl}	  =[];	# record fields list
 $_[0]
}

sub call { 
	&{$_[0]->{''}}(@_[1..$#_])
}

sub eval { 
	CORE::eval{&{$_[0]->{''}}(@_[1..$#_])}
}

sub fetch { 
	my $v =&{$_[0]->{''}}(@_[1..$#_]);
	if ($v) {@{$_[0]->{-rfl}} =map {$$_} @{$_[0]->{-rfr}}; $_[0]->{-rfl}}
	else	{@{$_[0]->{-rfl}} =(); undef}
}

sub fetchrow_arrayref {
	my $v =&{$_[0]->{''}}(@_[1..$#_]);
	if ($v) {@{$_[0]->{-rfl}} =@${v}{@{$_[0]->{NAME_db}}}; $_[0]->{-rfl}}
	else	{@{$_[0]->{-rfl}} =(); undef}
}

sub fetchrow_hashref {
	$_[0]->{-rec} =&{$_[0]->{''}}(@_[1..$#_]);
}

sub finish {
 $_[0]->{''} =undef;
}

sub close {
 $_[0]->{''} =undef;
}


#########################################################
# DBI Cursor object implementing filtering sub{}
#########################################################


package DBIx::Web::dbiCursor;
use strict;
use vars qw($AUTOLOAD);

sub new {
  my ($c, $i) =@_;
  my $s={''=>$i, @_[2..$#_]};
	# -rec=>{}, -rfr=>[], -flt=>sub{}; -query=>{}
  eval{$s->{'NAME'}=$s->{''}->{'NAME'}} 
	if ref($s->{''});
  bless $s, $c;
  $s
}


sub fetch { 
	return($_[0]->{''}->fetch(@_[1..$#_])) if !$_[0]->{-flt};
	my ($r, $k);
	while (1) {
		while ($k = each %{$_[0]->{-rec}}) {$_[0]->{-rec}->{$k} =undef};
		$r =$_[0]->{''}->fetch(@_[1..$#_]);
		last	if !$r || !$_[0]->{-flt} 
			|| &{$_[0]->{-flt}}($_[0],undef,$_[0]->{-rec})
	}
	$r
}

sub fetchrow_arrayref {
	return($_[0]->{''}->fetchrow_arrayref(@_[1..$#_])) if !$_[0]->{-flt};
	my ($r, $k);
	while (1) {
		while ($k = each %{$_[0]->{-rec}}) {$_[0]->{-rec}->{$k} =undef};
		$r =$_[0]->{''}->fetchrow_arrayref(@_[1..$#_]);
		last	if !$r || !$_[0]->{-flt} 
			|| &{$_[0]->{-flt}}($_[0],undef,$_[0]->{-rec})
	}
	$r
}

sub fetchrow_hashref {
	return($_[0]->{''}->fetchrow_hashref(@_[1..$#_])) if !$_[0]->{-flt};
	my ($r, $k);
	while (1) {
		while ($k = each %{$_[0]->{-rec}}) {$_[0]->{-rec}->{$k} =undef};
		$r =$_[0]->{''}->fetchrow_hashref(@_[1..$#_]);
		last	if !$r || !$_[0]->{-flt} 
			|| &{$_[0]->{-flt}}($_[0],undef,$_[0]->{-rec})
	}
	$r
}


sub finish {
 $_[0]->{''}->finish(@_[1..$#_])
}


sub close {
	eval {$_[0]->{''}->finish(@_[1..$#_])};
	$_[0]->{''}=undef;
}


sub AUTOLOAD {
	my $m =substr($AUTOLOAD, rindex($AUTOLOAD, '::')+2);
	confess("!object in AUTOLOAD of $AUTOLOAD") if !ref($_[0]);
	$_[0]->{''}->$m(@_[1..$#_])
}
