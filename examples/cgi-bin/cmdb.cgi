#!perl -w
BEGIN {
#push @INC, $1 .'sitel/lib' if !(grep /sitel/i, @INC) && ($INC[0] =~/(.+?[\\\/])lib$/i);
}
#$ENV{HTTP_ACCEPT_LANGUAGE} ='';

use DBIx::Web;
my $w =DBIx::Web->new(
  -title	=>'CMDB'	# title of application
#,-logo		=>'<img src="/icons/p.gif" border="0" />'
 ,-debug	=>1		# debug level
 ,-log          =>0             # logging
 ,-serial	=>1		# serial operation level
 ,-dbiarg	=>["DBI:mysql:cgibus","cgibus","********"]
 ,-dbiACLike	=>'rlike'	# dbi access control comparation, i.e. 'eq lc', 'rlike'
 ,-keyqn	=>1		# key query null comparation
 ,-path		=>'-ServerRoot' # datastore path
#,-cgibus	=>undef		# legacy mode
#,-url		=>'/dbix-web'	# filestore URL (/dbix-web or /cgi-bus)
 ,-urf		=>'-path'	# filestore filesystem URL
#,-fswtr	=>'System'	# filesystem writers (default is process account)
#,-login	=>/cgi-bin/ntlm/# login URL
#,-AuthUserFile	=>''		# apache users file
#,-AuthGroupFile=>''		# apache groups file
#,-usernt	=>1		# windows NT style for user names (0 - @, 1 - \\)
#,-userln	=>0		# short local usernames (0 - off, 1 - default)
 ,-ugadd	=>['Everyone','Guests']	# additional user groups
#,-rac		=>0		# record access control (0 - off, 1 - default)
#,-racAdmRdr	=>''		# record access control admin reader
#,-racAdmWtr	=>''		# record access control admin writer
#,-rfa		=>0		# record file attachments (0 - off, 1 - default)
#,-httpheader	=>{}		# http header arguments
#,-htmlstart	=>{}		# html start arguments
 ,-smtphost	=>'localhost'	# smtp mail server
 ,-smtpdomain	=>'localhost'	# smtp default domain
 );

					### CMDBm Settings

					### HelpDesk  Settings
#$w->{-a_cmdbh_larole} ={''=>''		# Support groups, or using 'uglist()'
#		,'group name' => 'group label'
#		};
$w->{-a_cmdbh_lmrole} =			# Manager roles
		$w->{-a_cmdbh_larole};
$w->{-a_cmdbh_vmrole} ={ '' => ''	# Manager assign (rec=>value||{values})
			,'work' => undef	# all off: $w->{-a_cmdbh_vmrole} =undef
			,'incident' => undef
			};
$w->{-a_cmdbh_lrrole} ={ '' => ''	# Read levels
			,'Everyone'	=> 'Everyone'
			};

					### CMDBm Predefinitions
$w->{-a_cmdbm_fh} =			# CMDBm field hide conditions
	sub{	my $k =ref($_[0]) ? $_[0]->{-pout}->{'record'} : $_[0];
		my $f =ref($_[1]) ? $_[1]->{-fld} : $_[1];
		 !$k
		? 0
		: $k eq 'all'
		? $f !~/^(?:name|system|service|application|type|os|invno|location|office|model|hardware|cpu|ram|hdd|action|computer|slot|device|port|ipaddr|macaddr|speed|duplex|interface|ugroup|role|user|definition)/
		: $k eq 'description'
		? $f !~/^(?:name|system|office|definition)/
		: $k eq 'service'
		? $f !~/^(?:name|system|application|office|definition)/
		: $k eq 'user'
		? $f !~/^(?:name|system|location|office|ugroup|user|definition)/
		: $k eq 'grouping'
	 	? $f !~/^(?:ugroup|role|user|definition)/
		: $k eq 'computer'
		? $f !~/^(?:name|system|type|os|invno|location|office|model|hardware|cpu|ram|hdd|port|ipaddr|ipmask|macaddr|speed|duplex|role|user|definition)/
		: $k eq 'interface'
		? $f !~/^(?:name|system|computer|port|ipaddr|ipmask|macaddr|speed|duplex|definition)/
		: $k eq 'device'
		? $f !~/^(?:name|system|slot|invno|location|office|model|hardware|definition)/
		: $k eq 'netint'
		? $f !~/^(?:name|system|slot|invno|service|ipaddr|ipmask|macaddr|speed|duplex|interface|definition)$/
		: $k eq 'connector'
		? $f !~/^(?:name|system|slot|device|port|definition)/
		: $k eq 'connection'
		? $f !~/^(?:system|slot|device|port|definition)/
		: $k eq 'usage'
		? $f !~/^(?:service|action|computer|interface|role|user|definition)/
		: 0 };
$w->{-a_cmdbm_fho} =			# CMDBm field optional hide condition
	sub{	(!$_ && ($_[2] !~/e/)) ||&{$_[0]->{-a_cmdbm_fh}}(@_)};
$w->{-a_cmdbm_fl} =			# CMDBm field link description
	['','recRead','name'];

					### HelpDesk Predefinitions
$w->{-a_cmdbh_rectype} ={		# record subtypes
			 'incident'	=>[qw(svc-rst svc-req sys-rst sys-evt)]
			,'work'		=>['','vendor']
			,'task'		=>['','vendor']
			,'solutuion'	=>['','faq','howto']
			,'error'	=>[qw(bug enhancmnt)]
			,'change'	=>[qw(change project release)]
			,'unavlbl'	=>[qw(part-schd full-schd part-uschd full-uschd)]
			,'note'		=>['','faq','howto']
			};
$w->{-a_cmdbh_fsvrclr} ={0=>'orangered'	# severity colours
			,1=>'orange'
			,2=>'yellow'
			,3=>'turquoise'
			,'3.5'=>'lavender'
			,4=>'lime'
			,''=>'lightgreen'};
$w->{-a_cmdbh_fsvrlds} =sub{		# -ldstyle with severity colours
			my $v =eval{$_[3]->{-rec}->{severity}};
			$v ='3.5'
				if (!defined($v) || ($v eq '4')) 
				&& $_[3]->{-rec}->{record}
				&& ($_[3]->{-rec}->{record} eq 'unavlbl')
				&& $w->{-a_cmdbh_fsvrclr}->{'3.5'};
			(defined($v) && ($v ne '') && ($w->{-a_cmdbh_fsvrclr}->{$v}) 
			&& ('background-color: ' .$w->{-a_cmdbh_fsvrclr}->{$v})) 
			|| ''};

$w->set(
    -menuchs	=>[	 'start'
			,'notes'
			,'hdesk', 'hdeskc', 'hdeskg'
			,'cmdbm', 'cmdbmn', 'cmdbmh'
			,'fulltext']
   ,-menuchs1	=>[	'','notes+','hdesk+','cmdbm+']
   ,-table	=>{
    'notes'=>{		### notes table
	 -lbl		=>'Notes'
	,-cmt		=>'Notes'
	,-lbl_ru	=>'Заметки'
	,-cmt_ru	=>'Заметки'
	,-expr		=>'cgibus.notes'
	,-null		=>''
	,-field		=>[
		 {-fld=>$w->tn('-rvcActPtr')
			,-flg=>'q'
			,-hide=>sub{!$_}
			},
		,{-fld=>'id'
			,-flg=>'kwq'
			,-lblhtml=>$w->tfoShow('id_',['idrm'])
			}, ''
		,{-fld=>$w->tn('-rvcInsWhen')
			,-flg=>'q'
			,-ldstyle=>'width: 20ex'
                        ,-ldprop=>'nowrap=true'
			,-lsthtml=>sub{/(?::\d\d)$/ ? $` : $_}
			}, ''
		,{-fld=>$w->tn('-rvcInsBy')
			,-flg=>'q'
			}, 
		,{-fld=>'idrm'
			,-flg=>'euq'
			,-hide=>$w->tfoHide('id_')
			},''
		,{-fld=>$w->tn('-rvcUpdWhen')
			,-flg=>'wq'
			,-ldstyle=>'width: 20ex'
			,-ldprop=>'nowrap=true'
			,-lsthtml=>sub{/(?::\d\d)$/ ? $` : $_}
			},''
		,{-fld=>$w->tn('-rvcUpdBy')
			,-edit=>0
			,-flg=>'wql'
			,-lhstyle=>'width: 10ex'
			,-lsthtml=>sub{$_[0]->htmlEscape($_[0]->udispq($_))}
			,-ldprop=>'nowrap=true'
			}
		,{-fld=>'otime'
			,-flg=>'l', -hidel=>1
			,-expr=> "CONCAT("
				."IF(status IN('edit','progress','do'), '', ' ')"
				.", utime)"
			,-lbl=>'Execution', -cmt=>'Fulfilment ordering of records'
			,-lbl_ru=>'Вып-е', -cmt_ru=>'Упорядочение записей по выполнению'
			,-lhstyle=>'width: 20ex'
			,-ldprop=>'nowrap=true'
			,-lsthtml=>sub{/(?::\d\d)$/ ? $` : $_}
			}
		,{-fld=>'prole'
			,-flg=>'euq'
			,-fdprop=>'nowrap=true'
			,-ddlb=>sub{$_[0]->uglist({})}
			#,-ddlbtgt=>[[undef,undef,','],['rrole',undef,',']]
			,-ddlbtgt=>[[undef,undef],['rrole',undef]]
			}, ''
		,{-fld=>'rrole'
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			#,-colspan=>3
			},''
		,{-fld=>'mailto'
			,-flg=>'euq'
			,-hide=>sub{ !$_ && ($_[2] !~/e/)}
			,-ddlb=>sub{$_[0]->{-ldapsrv}
				? $_[0]->ldapLst('-<>','',{},['mail','cn'])
				: $_[0]->uglist({})}
			,-ddlbtgt=>[[undef,undef,', ']]
			,-ddlbmsab=>1
			 }
		,{-fld=>$w->tn('-rvcState')
			,-inp=>{ -values=>['ok','edit','chk-out','deleted']
				,-labels_ru=>{'ok'=>'завершено','edit'=>'редакт-е','deleted'=>'удалено'}
				}
			,-flg=>'euql', -null=>undef
			,-lhstyle=>'width: 14ex'
			,-ldstyle=>sub{	/^(?:ok)$/
					? '' : 'color: red; font-weight: bold'}
			}, ''
		,{-fld=>'subject'
			,-flg=>'euqlm', -null=>undef
			,-inp=>{-asize=>60}
			,-colspan=>3
			}
		,"\f"
		,{-fld=>'comment'
			,-flg=>'eu'
			,-lblhtml=>'' # '<b>$_</b><br />'
			,-inp=>{-htmlopt=>1, -hrefs=>1, -arows=>5, -cols=>70}
			}
		,$w->tfsAll()
		]
		,$w->ttoRVC()
		,-dbd		=>'dbi'
		,-ridRef	=>[qw(idrm comment)]
		,-dbiACLike	=>'eq'
		,-racReader	=>[qw(rrole)]
		,-racWriter	=>[$w->tn('-rvcUpdBy'), $w->tn('-rvcInsBy'), 'prole']
		,-urm		=>[$w->tn('-rvcUpdWhen')]
		,-rfa		=>1
		,-cgiRun0A	=>sub{	$_[0]->{-udisp} ='+'
					# comments as group display names
					}
		,-recNew0C	=>sub{	$_[2]->{'idrm'} =$_[3]->{'id'}||'';
					foreach my $n (qw(prole rrole)) {
						$_[2]->{$n} =$_[3]->{$n} 
							if !$_[2]->{$n} && $_[3]->{$n};
						$_[0]->recLast($_[1],$_[2],['uuser'],[$n])
							if !$_[2]->{$n};
					}
					$_[2]->{'status'} ='ok' if !$_[2]->{'status'};
				}
		,-recChg0W	=>sub {
				$_[0]->smtpSend(-to=>$_[2]->{mailto}
						,-pout=>$_[2], -pcmd=>$_[1])
					if $_[2]->{mailto}
					&& ($_[2]->{$_[0]->tn('-rvcState')}
						=~/^(?:ok|no|do|progress|deleted)$/);
				}
		,-query		=>{	 -display=>[qw(otime status subject uuser)]
					,-frmLso=>['hierarchy']
					,-order=>'otime'
					,-keyord=>'-dall'
					}
		,-frmLsoAdd	=>
				[['hierarchy',undef,{-qkeyadd=>{'idrm'=>undef}}]
				]
                ,-frmLsc        =>
                                [{-val=>'otime',-cmd=>{}}
                                ,{-val=>'utime'}
                                ,{-val=>'ctime'}
                                ]
	}
   ,'cmdbm'=>{		### cmdbm table
	 -lbl		=>'CMDB'
	,-cmt		=>'CMDB - Configuration management database'
	,-lbl_ru	=>'КБД'
	,-cmt_ru	=>'КБД - Конфигурационная база данных'
	,-expr		=>'cgibus.cmdbm'
	,-null		=>''
	,-field		=>[
		sub{return('') if !$_[3]->{-print};
		'<td colspan=3>'
		.'<nobr>Configuration item approvement form</nobr>'
		.'</td></tr><tr>'
			}
		,{-fld=>$w->tn('-rvcActPtr')
			,-flg=>'q'
			,-hide=>sub{!$_}
			}, ''
		,{-fld=>$w->tn('-rvcInsWhen')
			,-flg=>'q'
			,-hide=>sub{$_[2] =~/p/}
			}, ''
		,{-fld=>$w->tn('-rvcInsBy')
			,-flg=>'q'
			,-hide=>sub{$_[2] =~/p/}
			}
		,{-fld=>'id'
			,-flg=>'kwq'
			}, ''
		,{-fld=>$w->tn('-rvcUpdWhen')
			,-flg=>'wq'
			,-ldstyle=>'width: 25ex'
			,-ldprop=>'nowrap=true'
			},''
		,{-fld=>$w->tn('-rvcUpdBy')
			,-edit=>0
			,-flg=>'wq'
			,-lhstyle=>'width: 10ex'
			}
		,{-fld=>$w->tn('-rvcState')
			,-inp=>{-values=>['new','change','delete','edit','chk-out','ok','deleted']
				,-labels_ru=>{'new'=>'ввести','change'=>'изменить','delete'=>'исключить','edit'=>'редакт-е','ok'=>'ok','deleted'=>'удалено'}
				}
			,-flg=>'euq', -null=>undef
			,-lhstyle=>'width: 5ex'
			,-ldstyle=>sub{	/^(?:ok)$/
					? '' : 'color: red; font-weight: bold'}
			,-fdstyle=>sub{$_[2] =~/p/ ? 'font-size: larger; font-weight: bolder; color: red': ''}
			}, ''
		,{-fld=>'authors'
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			,-ddlbtgt=>[[undef,undef,', '],['readers',undef,', ']]
			}, ''
		,{-fld=>'readers'
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			,-ddlbtgt=>[[undef,undef,', ']]
			,-colspan=>3
			 }
		,{-fld=>'record'
			,-cmt=>"'description' or documentation"
				."'service' (applicational or system);\n"
				."'user' or group,\n"
				."'grouping' of users;\n"
				."'computer' system,\n"
				."'interface' of computer into network;\n"
				."'network interface' to connect computer/interface;\n"
				."'device';\n"
				."named 'connector' or unnamed 'connection' or cabling of devices;\n"
				."'usage' of service by computer and/or user, usage of computer by user;\n"
			,-cmt_ru=>"'описание' (документация);\n"
				."'сервис' (прикладной или системный);\n"
				."'пользователь' или группа,\n"
				."'группирование' пользователей;\n"
				."'компьютер' или вычислительная установка,\n"
				."'интерфейс' компьютера в сеть;\n"
				."'интерфейс сети' для подключения компьютера/интерфейса;\n"
				."'устройство';\n"
				."именованный 'соединитель' и неименованное 'соединение' устройств;\n"
				."'применение' сервиса компьютером и/или пользователем, либо компьютера пользователем;\n"
			,-inp=>{-values=>['description','service','user','grouping','computer','interface','device','netint','connector','connection','usage']
				,-labels_ru=>{'description'=>'описание','service'=>'сервис'
						,'user'=>'пользователь','grouping'=>'группирование'
						,'computer'=>'компьютер','interface'=>'интерфейс'
						,'device'=>'устройство'
						,'connector'=>'соединитель'
						,'connection'=>'соединение'
						,'usage'=>'применение'
						,'netint'=>'инт.сети'}
				,-loop=>1
				}
			,-flg=>'euq', -null=>undef
			,-edit=>sub{$_[0]->{-pout}->{-new}}
			,-fdstyle=>sub{$_[2] =~/p/ ? 'font-size: larger; font-weight: bolder; color: red': ''}
			} # , ''
		,{-fld=>'name'
			,-lbl=>'Name', -cmt=>'Configuration item name'
			,-lbl_ru=>'Имя', -cmt_ru=>'Имя конфигурационной единицы'
			,-flg=>'euq', -null=>undef
			,-inp=>{-asize=>60}
			,-hidel=>$w->{-a_cmdbm_fh}
			,-fdstyle=>sub{$_[2] =~/p/ ? 'font-size: larger; font-weight: bolder; color: red': 'font-size: larger; font-weight: bolder;'}
			,-fnhref=>sub{
				$_ && ($_[2] !~/p/)
				&& $_[0]->urlCmd('',-form=>'hdesk',-qwhere=>$_[0]->dbi->quote($_) .' IN(object, application, location)',-cmd=>'recList')
				}
			,-colspan=>3
			}
		,{-fld=>'vsubject'
			,-lbl=>'Subject'
			,-lbl_ru=>'Тема'
			,-flg=>'-', -hidel=>1
			,-expr=>"IF(name IS NOT NULL AND name !='',"
				."CONCAT_WS(' - ', name, definition),"
				."CONCAT_WS(' - ', name, system, slot, service, action, computer, interface, device, port, ugroup, role, user, definition))"
			,-lsthtml=>sub{	my $r =$_[3]->{-rec};
					# return($_[0]->htmlEscape($r->{definition}));
					$r->{-a_a} =$_[0]->lngslot($_[0]->{-table}->{cmdbm}->{-mdefld}->{action}->{-inp},'-labels')
						if !$r->{-a_a};
					$r->{-a_r} =$_[0]->lngslot($_[0]->{-table}->{cmdbm}->{-mdefld}->{role}->{-inp},'-labels')
						if !$r->{-a_r};
					$_[0]->htmlEscape(join(' - ', map {!$_ ? () : $_}
                                        $r->{name}
					? (@$r{qw(name type model invno office device interface userdef definition)})
							# ??? review
					: (@$r{qw(name system slot service)}
					, join(' ', map {!$_ ? () : $_} 
						  $r->{action} && $r->{-a_a}->{$r->{action}} || $r->{action}
						, ($r->{interface}||'') eq ($r->{computer}||'')
						? () : $r->{interface}
						, $r->{computer})
					, @$r{qw(device port ugroup)}
					, join(' ', map {!$_ ? () : $_}
						  $r->{role} && $r->{-a_r}->{$r->{role}} || $r->{role}
						, $r->{user}
						, $r->{userdef}
						)
					, @$r{qw(definition)}
					)))}
			# ,-lsthtml=>undef
			}
		,{-fld=>'vorder'
			,-lbl=>'Sorting'
			,-lbl_ru=>'Сортировка'
			,-flg=>'-', -hidel=>1
			,-expr=>"IF(record='description',0,IF(record='service',1,IF(record='device',2,IF(record='computer' OR record='interface',3,IF(record='netint',4,IF(record='connection' OR record='connector',5,IF(record='user',6,IF(record='usage' AND action='supplier',7,IF(record='usage' AND role !='user',8,9)))))))))"
			}
		,{-fld=>'vordh'
			,-lbl=>'Sorting'
			,-lbl_ru=>'Сортировка'
			,-flg=>'f', -hidel=>1
			,-expr=>"IF(system IS NULL OR system='',0,IF(record='description',1,IF(record='service',2,IF(record='device',3,IF(record='computer' OR record='interface',4,IF(record='netint',4,IF(record='connection' OR record='connector',5,IF(record='user',6,IF(record='usage' AND action='supplier',7,IF(record='usage' AND role !='user',8,9))))))))))"
			}
		,{-fld=>'system'
			,-lbl=>'System', -cmt=>'System including descriptions, services, users, computers/interfaces, devices'
			,-lbl_ru=>'Система', -cmt_ru=>'Система, включающая описания, сервисы, пользователей, компьютеры/интерфейсы, устройства'
			,-flg=>'euq'
			#,-inp=>{-asize=>60}
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb=> 'cmdbmn'
			,-ddlb=> sub{$_[0]->cgiQuery('cmdbmn',undef
					,{-qwhere=>"record IN('description','service','computer','interface','device','netint')"
					, -qkey=>{$_ ? ('system'=>$_) : ('system'=>'')}})}
			,-ddlbloop=>1
			,-form=>$w->{-a_cmdbm_fl}
			,-colspan=>5
			}
		,{-fld=>'slot'
			,-lbl=>'Slot', -cmt=>'Slot of the system/computer/device where device installed'
			,-lbl_ru=>'Слот', -cmt_ru=>'Слот установки устройства в систему/компьютер/устройство'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho} 
			,-ddlb =>sub{$_[0]->cgiQueryFv('','slot')}, -form=>'cmdbm'
			,-colspan=>5
			}
		,{-fld=>'type'
			,-lbl=>'Type', -cmt=>'Type of computer, description or typisation service, may be in \'Types\' container'
			,-lbl_ru=>'Тип', -cmt_ru=>'Тип компьютера, описание или типизирующий сервис, может находиться в контейнере \'Типы\''
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb=> sub{$_[0]->cgiQuery('cmdbmn',undef
					,{-qkey=>{'record'=>['service','description']
					 ,$_ ? ('system'=>$_) : ('system'=>['','Types','Типы'])}
					,$_ ? () : (-qorder=>['vordh','name'])
					})}
			,-ddlbloop=>1
			,-form=>$w->{-a_cmdbm_fl}
			,-colspan=>3
			},''
		,{-fld=>'os'
			,-lbl=>'OS', -cmt=>'Operation System, description, may be in \'OS\' container'
			,-lbl_ru=>'ОС', -cmt_ru=>'Операционная система / сетевое программное обеспечение, описание, может находиться в контейнере \'ОС\''
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb=> sub{$_[0]->cgiQuery('cmdbmn',undef
					,{-qkey=>{'record'=>['service','description']
					 ,$_ ? ('system'=>$_) : ('system'=>['','OS','ОС'])}
					,$_ ? () : (-qorder=>['vordh','name'])
					})}
			,-ddlbloop=>1
			,-form=>$w->{-a_cmdbm_fl}
			},
		,{-fld=>'invno'
			,-lbl=>'Inv#', -cmt=>'Inventory number of computer'
			,-lbl_ru=>'Инв№', -cmt_ru=>'Инвентарный или заводской номер'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			},''
		,{-fld=>'office'
			,-lbl=>'Office', -cmt=>'Office or subdivision, description or organisation structure service, may be in \'Offices\' container'
			,-lbl_ru=>'Подразд.', -cmt_ru=>'Подразделение, отдел, служба, описание или оргструктурный сервис, может находиться в контейнере \'Подразделения\''
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb=> sub{$_[0]->cgiQuery('cmdbmn',undef
					,{-qwhere=>"record IN('description','service','user')"
						.($_ ? '' : " AND (system IS NULL OR system='' OR system IN('Offices','Подразделения') OR record='user')")
					, -qkey=>{$_ ? ('system'=>$_) : ()}
					, $_ ? () : (-qorder=>['vordh','name'])
					})}
			,-ddlbloop=>1
			,-form=>$w->{-a_cmdbm_fl}
			},''
		,{-fld=>'location'
			,-lbl=>'Location', -cmt=>'Location of computer or device, description or apartment service, may be in \'Locations\' container'
			,-lbl_ru=>'Место', -cmt_ru=>'Местонахождение компьютера или устройства, описание или сервис размещения, может находиться в контейнере \'Местонахождения\''
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb=> sub{$_[0]->cgiQuery('cmdbmn',undef
					,{-qkey=>{'record'=>['service','description']
					 ,$_ ? ('system'=>$_) : ('system'=>['','Locations','Apartments','Местонахождения','Помещения'])}
					,$_ ? () : (-qorder=>['vordh','name'])
					})}
			,-ddlbloop=>1
			,-form=>$w->{-a_cmdbm_fl}
			}
		,{-fld=>'model'
			,-lbl=>'Model', -cmt=>'Model of computer or device, descriptio or typisation service, may be in \'Models\' container'
			,-lbl_ru=>'Модель', -cmt_ru=>'Модель компьютера или устройства, описание или типизирующий сервис, может находиться в контейнере \'Модели\''
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb=> sub{$_[0]->cgiQuery('cmdbmn',undef
					,{-qkey=>{'record'=>['service','description']
					 ,$_ ? ('system'=>$_) : ('system'=>['','Models','Модели'])}
					,$_ ? () : (-qorder=>['vordh','name'])
					})}
			,-ddlbloop=>1
			,-form=>$w->{-a_cmdbm_fl}
			},''
		,{-fld=>'hardware'
			,-lbl=>'Hardware', -cmt=>'Hardware description'
			,-lbl_ru=>'Характ.', -cmt_ru=>'Описание аппаратного обеспечения'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-inp=>{-asize=>60}
			,-colspan=>3
			},
		,{-fld=>'cpu'
			,-lbl=>'CPU', -cmt=>'Central Processor Unit'
			,-lbl_ru=>'CPU', -cmt_ru=>'Процессор'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb =>sub{$_[0]->cgiQueryFv('','cpu')}, -form=>'cmdbm'
			}, ''
		,{-fld=>'ram'
			,-lbl=>'RAM', -cmt=>'RAM capacity, Mb'
			,-lbl_ru=>'RAM', -cmt_ru=>'Объем оперативной памяти, Mb'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			}, ''
		,{-fld=>'hdd'
			,-lbl=>'HDD', -cmt=>'Main HDD capacity, Gb'
			,-lbl_ru=>'HDD', -cmt_ru=>'Объем основной дисковой памяти, Gb'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			}
		,{-fld=>'application'
			,-lbl=>'Application', -cmt=>'Application to use a service, description or service, may be in \'Applications\' container'
			,-lbl_ru=>'Приложение', -cmt_ru=>'Приложение доступа к сервису, описание или сервис, может находиться в контейнере \'Приложения\''
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb=> sub{$_[0]->cgiQuery('cmdbmn',undef
					,{-qkey=>{'record'=>['service','description']
					 ,$_ ? ('system'=>$_) : ('system'=>['','Applications','Приложения'])}
					,$_ ? () : (-qorder=>['vordh','name'])
					})}
			,-ddlbloop=>1
			,-form=>$w->{-a_cmdbm_fl}
			,-colspan=>5
			}
		,{-fld=>'service'
			,-lbl=>'Service', -cmt=>'Service being used/supplied'
			,-lbl_ru=>'Сервис', -cmt_ru=>'Сервис, применяемый/поставляемый'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb=> sub{$_[0]->cgiQuery('cmdbmn',undef
					,{-qwhere=>"record IN('description','service','computer','interface')"
					, -qkey=>{$_ ? ('system'=>$_) : ('system'=>'')}})}
			,-ddlbloop=>1
			,-form=>$w->{-a_cmdbm_fl}
			,-colspan=>5
			}
		,{-fld=>'device'
			,-lbl=>'Device', -cmt=>'Device/computer connected'
			,-lbl_ru=>'Устройство', -cmt_ru=>'Подключаемое устройство/компьютер'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb=> sub{$_[0]->cgiQuery('cmdbmn',undef
					,{-qwhere=>"record IN('description','service','computer','device','netint')"
						.($_ ? '' : " AND (system IS NULL OR system='' OR system IN('Computers','Компьютеры') OR record='computer')")
					, -qkey=>{$_ ? ('system'=>$_) : ()}
					, $_ ? () : (-qorder=>['vordh','name'])
					})}
			,-form=>$w->{-a_cmdbm_fl}
			,-colspan=>5
			}
		,{-fld=>'action'
			,-lbl=>'Action', -cmt=>'Action of the computer delivering/accepting service'
			,-lbl_ru=>'Действие', -cmt_ru=>'Действие вычислительной установки по предоставлению или потреблению услуги'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-inp=>{-values=>['','user','supplier']
				,-labels_ru=>{''=>'','user'=>'потребитель','supplier'=>'поставщик'}
				}
			}, ''
		,{-fld=>'computer'
			,-lbl=>'Computer', -cmt=>'Computer installation (server, cluster, desktop, or another)'
			,-lbl_ru=>'Компьютер', -cmt_ru=>'Вычислительная установка (сервер, кластер, настольная система, и т.п.)'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb=> sub{$_[0]->cgiQuery('cmdbmn',undef
					,{-qwhere=>"record IN('description','service','computer')"
						.($_ ? '' : " AND (system IS NULL OR system='' OR system IN('Computers','Компьютеры') OR record='computer')")
					, -qkey=>{$_ ? ('system'=>$_) : ()}
					, $_ ? () : (-qorder=>['vordh','name'])
					})}
			,-ddlbloop=>1
			,-form=>$w->{-a_cmdbm_fl}
			},''
		,{-fld=>'interface'
			,-lbl=>'Interface', -cmt=>'Computer\'s network interface'
			,-lbl_ru=>'Интерфейс', -cmt_ru=>'Сетевой интерфейс вычислительной установки'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb=> sub{$_[0]->cgiQuery('cmdbmn',undef
					,{-qwhere=>"record in('interface','computer')"
					,-qkey=>{$_[0]->{-pout}->{computer}||$_[0]->{-pout}->{device}
						? ('computer'=>$_[0]->{-pout}->{computer}||$_[0]->{-pout}->{device})
						: ()}}
					)}
			,-form=>sub{['',-cmd=>'recRead',-form=>'cmdbm'
					,-key=>{'name' =>$_||'?'}]}
			,-form=>$w->{-a_cmdbm_fl}
			}
		,{-fld=>'port'
			,-lbl=>'Port', -cmt=>'Device\'s port connected'
			,-lbl_ru=>'Порт', -cmt_ru=>'Подключаемый порт устройства'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb =>sub{$_[0]->cgiQueryFv('','port')}, -form=>'cmdbm'
			,-colspan=>5
			}
		,{-fld=>'ipaddr'
			,-lbl=>'IP addr', -cmt=>'TCP/IP address'
			,-lbl_ru=>'Адрес IP', -cmt_ru=>'Адрес TCP/IP'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			}, ''
		,{-fld=>'ipmask'
			,-lbl=>'IP mask', -cmt=>'TCP/IP network mask'
			,-lbl_ru=>'Маска IP', -cmt_ru=>'Маска сети TCP/IP'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			}, ''
		,{-fld=>'macaddr'
			,-lbl=>'MAC', -cmt=>'MAC address'
			,-lbl_ru=>'MAC', -cmt_ru=>'Адрес MAC'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			}
		,{-fld=>'speed'
			,-lbl=>'Speed', -cmt=>'Network speed mbit/sec'
			,-lbl_ru=>'Скорость', -cmt_ru=>'Скорость сети mbit/sec'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-inp=>{-values=>['',10,100,1000,10000]}
			},''
		,{-fld=>'duplex'
			,-lbl=>'Duplex', -cmt=>'Network speed mbit/sec'
			,-lbl_ru=>'Дуплекс', -cmt_ru=>'Режим дуплекса сети'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-inp=>{-values=>['',0,1], -labels=>{0=>'Off', 1=>'On'}}
			}
		,{-fld=>'ugroup'
			,-lbl=>'Group', -cmt=>'Group including user'
			,-lbl_ru=>'Группа', -cmt_ru=>'Группа, в которую включается пользователь'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb=> sub{$_[0]->cgiQuery('cmdbmn',undef
					,{-qwhere=>"record IN('description','service','user')"
						.($_ ? '' : " AND (system IS NULL OR system='' OR system IN('Users','Пользователи') OR record='user')")
					, -qkey=>{$_ ? ('system'=>$_) : ()}
					, $_ ? () : (-qorder=>['vordh','name'])
					})}
			,-ddlbloop=>1
			,-form=>$w->{-a_cmdbm_fl}
			,-colspan=>5
			}
		,{-fld=>'role'
			,-lbl=>'Role', -cmt=>'Role of the user'
			,-lbl_ru=>'Роль', -cmt_ru=>'Роль пользователя'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-inp=>{-values=>['','user','responsible','sysadmin','sysadmin double','appadmin','appadmin double','security','security double']
				,-labels_ru=>{''=>'','user'=>'пользователь'
						,'responsible'=>'ответственный'
						,'sysadmin'=>'системный адм-р'
						,'sysadmin double'=>'дублер сист.адм.'
						,'appadmin'=>'прикладной адм-р'
						,'appadmin double'=>'дублер прикл.адм.'
						,'security'=>'адм-р безопасности'
						,'security double'=>'дублер адм.безоп.'
						}
				}
			}, ''
		,{-fld=>'user'
			,-lbl=>'User', -cmt=>'User name'
			,-lbl_ru=>'Пользователь', -cmt_ru=>'Имя пользователя'
			,-flg=>'euq'
			,-hidel=>$w->{-a_cmdbm_fho}
			,-ddlb=> sub{$_[0]->cgiQuery('cmdbmn',undef
					,{-qwhere=>"record IN('description','service','user')"
						.($_ ? '' : " AND (system IS NULL OR system='' OR system IN('Users','Пользователи') OR record='user')")
					, -qkey=>{$_ ? ('system'=>$_) : ()}
					, $_ ? () : (-qorder=>['vordh','name'])
					})}
			,-ddlbloop=>1
			,-form=>$w->{-a_cmdbm_fl}
			,-inphtml=>sub{	return('$_') if !$_ || ($_[2] =~/eq/);
					$_[0]->htmlEscape(
						'$_' .($_[0]->{-pout}->{userdef} ? ' - ' .$_[0]->{-pout}->{userdef} : ''))
					}
			,-lsthtml=>sub{$_[0]->htmlEscape($_[3]->{-rec}->{userdef}
					? $_ .' - ' .$_[3]->{-rec}->{userdef}
					: ($_||''))}
			,-colspan=>3
			}
		,{-fld=>'userdef'
			,-lbl=>'UserDef', -cmt=>'User definition'
			,-lbl_ru=>'ОпрПольз', -cmt_ru=>'Определение пользователя'
			,-flg=>'', -hidel=>1
			}
		,{-fld=>'definition'
			,-lbl=>'Def', -cmt=>'Configuration item short definition'
			,-lbl_ru=>'Опр-е', -cmt_ru=>'Определение (краткое описание) конфигурационной единицы'
			,-flg=>'euq', -null=>undef
			,-inp=>{-asize=>100}
			,-hidel=>$w->{-a_cmdbm_fh}
			,-colspan=>5
			,-fdstyle=>sub{$_[2] =~/p/ ? 'font-size: larger; font-weight: bolder; color: red': 'font-size: larger; font-weight: bolder;'}
			}
		,"\f"
		,{-fld=>'comment'
			,-flg=>'eu'
			,-lblhtml=>'' # '<b>$_</b><br />'
			,-inp=>{-htmlopt=>1, -hrefs=>1, -arows=>5, -cols=>70}
			}
		,$w->tfsAll() # ,$w->tfdRFD(),$w->tfvVersions(),$w->tfvReferences()
		, sub {	my $s =$_[0];
			my $d =$_[0]->{-pout};
			my $c =$_[3];
			return('') if ($s->{-pcmd}->{-cmg} eq 'recQBF');
			return('') if !$d->{'record'};
			local $s->{-uiclass} ='tfvReferences';
			my $vw =sub{
				my $qwhr ='('
					.join(') AND ('
						,$_[0] =~/\s|[^\w\d]/ ? shift : ()
						,@_
						? join(' OR '
							, map {"$_=" .$s->dbi->quote($d->{name})
								} @_)
						: ()
						) .')';
				$s->cgiLst('cmdbmv'
					,{-qflghtml=>
					  '<div align="right" style="font-size: smaller;"><hr />'
					  .($c && $c->{-print}
					   ? ''
					   : $s->cgi->a({-href=>
						$s->urlCmd('',-cmd=>'frmCall'
							,-form=>'cmdbm'
							,-qwhere=>$qwhr)
						,-title=>$s->lng(1,'recQBF')
						}, $s->lng(0,'recQBF')))
						."</div>\n"
					 ,-qorder=>['vorder','vsubject']
					 ,-qwhere=> $qwhr }
					)};
			my $va =sub{
				my $qwhr ='('
					.join(') AND ('
						,$_[0] =~/\s|[^\w\d]/ ? shift : ()
						,@_
						? join(' OR '
							, map {"$_=" .$s->dbi->quote($d->{name})
								} @_)
						: ()
						) .')';
				$s->cgiLst('-','cmdbmva'
					,{-qflghtml=>$s->cgi->hr() ."\n"
					,-qwhere=> $qwhr}
					)};
			if (!$d->{name}) {
			}
			elsif ($d->{'record'} eq 'description') {
				&$vw(qw(system service application computer type model os location office));
			}
			elsif ($d->{'record'} eq 'service') {
				&$vw(qw(system service application computer type model os location office));
				# &$va(qw(service));
			}
			elsif ($d->{'record'} eq 'user') {
				&$vw(qw(user));
				&$vw(qw(ugroup));
			}
			elsif ($d->{'record'} eq 'computer') {
				&$vw("id !=" .$s->dbi->quote($d->{id}||0)
					,qw(computer device interface service system))
			}
			elsif ($d->{'record'} eq 'interface') {
				&$vw("id !=" .$s->dbi->quote($d->{id}||0)
					,qw(interface service))
			}
			elsif ($d->{'record'} eq 'device') {
				&$vw(qw(device));
				&$vw(qw(system));
			}
			elsif ($d->{'record'} eq 'netint') {
				&$vw(qw(system));
			}
			''}
		, sub {	return('') if !$_[3]->{-print};
			"<br/><hr/>\n"
			."Approvement signatures<br/><br/>\n"
			}
		]
		,$w->ttoRVC()
		,-dbd		=>'dbi'
		,-dbiACLike	=>'rlike'
		,-racReader	=>[qw(readers)]
		,-racWriter	=>[$w->tn('-rvcUpdBy'), 'authors']
		,-urm		=>[$w->tn('-rvcUpdWhen')]
		,-rfa		=>1
		,-recNew0C	=>sub{
			foreach my $n (qw(authors readers)) {
				$_[2]->{$n} =$_[3]->{$n}
					if !$_[2]->{$n} && $_[3]->{$n};
				$_[0]->recLast($_[1],$_[2],['uuser'],[$n])
					if !$_[2]->{$n};
			}
			# !!! only visible fields will be transfered changing record type
			if (!$_[3]->{'record'}) {
			}
			elsif ($_[3]->{'record'} eq 'description') {
				$_[2]->{'record'}    =$_[3]->{'record'}	if !$_[2]->{'record'};
				$_[2]->{'name'}   =$_[3]->{'name'} .'/'	if !$_[2]->{'name'};
				$_[2]->{'system'} =$_[3]->{'name'}	if !$_[2]->{'system'};
				$_[2]->{'service'}=$_[3]->{'name'}	if !$_[2]->{'service'};
			}
			elsif ($_[3]->{'record'} eq 'service') {
				$_[2]->{'record'} =$_[3]->{'record'}	if !$_[2]->{'record'};
				$_[2]->{'name'}   =$_[3]->{'name'} .'/'	if !$_[2]->{'name'};
				$_[2]->{'system'} =$_[3]->{'name'}	if !$_[2]->{'system'};
				$_[2]->{'service'}=$_[3]->{'name'}	if !$_[2]->{'service'};
			}
			elsif ($_[3]->{'record'} eq 'user') {
				$_[2]->{'record'}='grouping'		if !$_[2]->{'record'};
				$_[2]->{'user'}  =$_[3]->{'name'}	if !$_[2]->{'user'};
			}
			elsif ($_[3]->{'record'} eq 'grouping') {
				$_[2]->{'record'} =$_[3]->{'record'}	if !$_[2]->{'record'};
				$_[2]->{'user'}   =$_[3]->{'user'}	if !$_[2]->{'user'};
			}
			elsif ($_[3]->{'record'} eq 'computer') {
				$_[2]->{'record'}   ='usage'		if !$_[2]->{'record'};
				foreach my $n (qw(computer device)) {
					$_[2]->{$n} =$_[3]->{'name'} if !$_[2]->{$n}
				}
				foreach my $n (qw(port urole user)) {
					$_[2]->{$n} =$_[3]->{$n} if !$_[2]->{$n}
				}
			}
			elsif ($_[3]->{'record'} eq 'interface') {
				$_[2]->{'record'} ='usage'		if !$_[2]->{'record'};
				foreach my $n (qw(computer device)) {
					$_[2]->{$n} =$_[3]->{'computer'} if !$_[2]->{$n}
				}
				foreach my $n (qw(interface)) {
					$_[2]->{$n} =$_[3]->{'name'} if !$_[2]->{$n}
				}
				foreach my $n (qw(port urole user)) {
					$_[2]->{$n} =$_[3]->{$n} if !$_[2]->{$n}
				}
			}
			elsif ($_[3]->{'record'} eq 'device') {
				$_[2]->{'record'} ='connection'		if !$_[2]->{'record'};
				$_[2]->{'device'} =$_[3]->{'name'}	if !$_[2]->{'device'};
			}
			elsif ($_[3]->{'record'} eq 'connection') {
				$_[2]->{'record'}  =$_[3]->{'record'}	if !$_[2]->{'record'};
				foreach my $n (qw(system slot computer device interface port)) {
					$_[2]->{$n} =$_[3]->{$n} if !$_[2]->{$n}
				}
			}
			elsif ($_[3]->{'record'} eq 'usage') {
				$_[2]->{'record'}    =$_[3]->{'record'}	if !$_[2]->{'record'};
				foreach my $n (qw(service action computer device interface role user)) {
					$_[2]->{$n} =$_[3]->{$n} if !$_[2]->{$n}
				}
			}
			$_[2]->{'record'} ='description' if !$_[2]->{'record'};
			$_[2]->{'status'} ='new'	 if !$_[2]->{'status'};
			}
		,-recEdt0R	=> sub{
			$_[2]->{computer} =$_[2]->{name} 
				if $_[2]->{record} 
				&& ($_[2]->{record} eq 'computer');
			}
		,-recChg0R	=> sub{
			$_[0]->die('"' .$_[0]->lnglbl($_[0]->{-table}->{cmdbm}->{-mdefld}->{record},'-fld')
				.'" - '
				.$_[0]->lng(0,'fldReqStp'))
				if !$_[2]->{record};
			foreach my $f (@{$_[0]->{-table}->{'cmdbm'}->{-field}}) {
				next if !ref($f) ||(ref($f) ne 'HASH') || !$f->{-fld};
				next if !&{$_[0]->{-a_cmdbm_fh}}($_[2]->{record}, $f->{-fld});
				next if  &{$_[0]->{-a_cmdbm_fh}}('all', $f->{-fld});
				$_[2]->{$f->{-fld}} =undef;
			}
			if ($_[2]->{record} eq 'computer') {
				$_[2]->{computer} =$_[2]->{name}
			}
			if ($_[2]->{record} eq 'usage') {
				$_[2]->{action} =undef
					if !$_[2]->{computer};
				$_[2]->{interface} =undef
					if !$_[2]->{computer}
					|| !$_[2]->{action};
				$_[2]->{role} =undef
					if !$_[2]->{user};
				$_[2]->{user} =undef
					if !$_[2]->{role};
			}
			if (!&{$_[0]->{-a_cmdbm_fh}}($_[2]->{record}, 'user')) {
				my $v = $_[2]->{user}
					? $_[0]->recRead(-table=>'cmdbm',-test=>1, -key=>{name=>$_[2]->{user}})
					: undef;
				$_[2]->{userdef} =$v
					? $v->{definition}
					: undef;
			}
			if (!&{$_[0]->{-a_cmdbm_fh}}($_[2]->{record}, 'name')) {
				$_[0]->die('"' .$_[0]->lnglbl($_[0]->{-table}->{cmdbm}->{-mdefld}->{name},'-fld')
					.'" - '
					.$_[0]->lng(0,'fldReqStp'))
					if !$_[2]->{name};
				$_[0]->die('"' .$_[0]->lnglbl($_[0]->{-table}->{cmdbm}->{-mdefld}->{name},'-fld')
					.'" - '
					.$_[0]->lng(0,'fldChkStp'))
					if $_[0]->recLast({-table=>$_[1]->{-table}, -excl=>1, -version=>0}
						,$_[2], ['name'])
			}
			}
		,-recUpd0R	=> sub{
			if (($_[2]->{record} ne $_[3]->{record})
			&& !$_[0]->uadmin()
				) {
				$_[0]->die('"' .$_[0]->lnglbl($_[0]->{-table}->{cmdbm}->{-mdefld}->{record},'-fld')
					.'" - '
					.$_[0]->lng(0,'fldChkStp'))
			}
			if (!&{$_[0]->{-a_cmdbm_fh}}($_[2]->{record}, 'name')) {
				if (($_[2]->{name}||'') ne ($_[3]->{name}||'')) {
					$_[0]->die('"' .$_[0]->lnglbl($_[0]->{-table}->{cmdbm}->{-mdefld}->{name},'-fld')
						.'" - '
						.$_[0]->lng(0,'fldChkStp'))
						if 0 && !$_[0]->uadmin();
					foreach my $n (qw(system service application type os model location user ugroup office computer interface device)) {
						$_[0]->recUtr(
							{-table=>$_[1]->{-table}
							, -version=>1, -excl=>1
								}
							,{'name'=>$n},$_[2],$_[3])
					}
				}
				if ($_[2]->{record} eq 'user'
				&& (($_[2]->{definition}||'') ne ($_[3]->{definition}||''))) {
						$_[0]->recUtr(
							{-table=>$_[1]->{-table}
							 ,-version=>1, -excl=>1}
							,{'name'=>'user'
							 ,'definition'=>'userdef'}
							,$_[2],$_[3])
				}
			}
			}
		,-query		=>{	 -display=>[qw(utime uuser status record vsubject)]
					,-order=>'utime'
					,-keyord=>'-dall'
					}
		,-frmLsc	=>
				[{-val=>'utime',-cmd=>{}}
				,['vsubject',undef
					,sub {	$_[3]->{-order} ='vsubject asc, utime desc';
						}]
				]
		,-limit		=>1024
	}
   ,'hdesk'=>{		### hdesk table
	 -lbl		=>'Service Desk'
	,-cmt		=>'Service Desk for requests and incidents'
	,-lbl_ru	=>'Центр Обслуж.'
	,-cmt_ru	=>'Центр обслуживания запросов и инцидентов'
	,-expr		=>'cgibus.hdesk'
	,-null		=>''
	,-field		=>[
		{-fld=>$w->tn('-rvcActPtr')
			,-flg=>'q'
			,-hide=>sub{!$_}
			},
		,{-fld=>'id'
			,-flg=>'kwq'
			#,-lblhtml=>$w->tfoShow('id_',['idrm'])
			,-fhstyle=>sub{	my $v =$_[0]->{-pout}->{severity};
					defined($v) && ($v ne '4') && $_[0]->{-a_cmdbh_fsvrclr}->{$v}
					&& ($_[2] !~/[q]/)
					? 'color: ' .$_[0]->{-a_cmdbh_fsvrclr}->{$v}
				#	? 'background-color: ' .$_[0]->{-a_cmdbh_fsvrclr}->{$v}
				#	? 'border: 1px solid ' .$_[0]->{-a_cmdbh_fsvrclr}->{$v}
				#	? 'border: 0 solid ' .$_[0]->{-a_cmdbh_fsvrclr}->{$v} .'; border-bottom-width: thin'
					: ''}
			}, ''
		,{-fld=>$w->tn('-rvcInsWhen')
			,-flg=>'q'
			,-ldstyle=>$w->{-a_cmdbh_fsvrlds}
			,-fdprop=>'nowrap=true'
			,-ldprop=>'nowrap=true'
			,-lsthtml=>sub{/(?::00|\s00:00:00|:\d\d)$/ ? $` : $_}
			}, ''
		,{-fld=>$w->tn('-rvcInsBy')
			,-flg=>'q'
			,-fdprop=>'nowrap=true'
			}
		,"\n\t\t"
		,{-fld=>$w->tn('-rvcUpdWhen')
			,-flg=>'wq'
			,-fdprop=>'nowrap=true'
			,-ldstyle=>$w->{-a_cmdbh_fsvrlds}
			,-ldprop=>'nowrap=true'
			,-lsthtml=>sub{/(?::00|\s00:00:00|:\d\d)$/ ? $` : $_}
			},''
		,{-fld=>$w->tn('-rvcUpdBy')
			,-edit=>0
			,-flg=>'wq'
			,-fdprop=>'nowrap=true'
			,-lhstyle=>'width: 10ex'
			}
		,{-fld=>'vftime'
			,-flg=>'f', -hidel=>1
			,-expr=>'COALESCE(hdesk.etime, hdesk.utime)'
			,-lbl=>'Finish', -cmt=>'Finish time of record described by'
			,-lbl_ru=>'Заверш', -cmt_ru=>'Дата и время завершения события или обновления записи'
			,-ldstyle=>$w->{-a_cmdbh_fsvrlds}
			,-ldprop=>'nowrap=true'
			,-lsthtml=>sub{/(?::00|\s00:00:00|:\d\d)$/ ? $` : $_}
			 }
		,{-fld=>'votime'
			,-flg=>'f', -hidel=>1
			,-expr=> "CONCAT("
				."IF(hdesk.status IN('draft','do','progress','edit','rollback','delay'), '', ' ')"
				.", COALESCE(hdesk.etime, hdesk.utime))"
			,-lbl=>'Execution', -cmt=>'Fulfilment records order'
			,-lbl_ru=>'Вып-е', -cmt_ru=>'Упорядочение по выполнению записей'
			,-ldstyle=>$w->{-a_cmdbh_fsvrlds}
			,-ldprop=>'nowrap=true'
			,-lsthtml=>sub{/(?::00|\s00:00:00|:\d\d)$/ ? $` : $_}
			 }
		,{-fld=>'votimej'
			,-flg=>'-', -hidel=>1
			,-expr=> "CONCAT("
				."IF(hdesk.status IN('draft','do','progress','edit','rollback','delay'), '', ' ')"
				.", GREATEST(COALESCE(MAX(j.utime),hdesk.utime),hdesk.utime))"
			,-lbl=>'Exec/below', -cmt=>'Record/subrecords update order'
			,-lbl_ru=>'Вып/под', -cmt_ru=>'Упорядочение по изменению записи/подзаписей'
			,-ldstyle=>$w->{-a_cmdbh_fsvrlds}
			,-ldprop=>'nowrap=true'
			,-lsthtml=>sub{/(?::00|\s00:00:00|:\d\d)$/ ? $` : $_}
			 }
		,{-fld=>'idrm'
			,-flg=>'euq'
			,-hide=>$w->tfoHide('id_')
			,-hide=>sub{ !$_ && ($_[2] !~/e/)}
			},''
		,{-fld=>'idpr'
			,-flg=>'euq'
			,-lbl=>'PrevRec', -cmt=>'Causal/Previous Record ID' #'vqis"'
			,-lbl_ru=>'Предш', -cmt_ru=>'Уникальный идентификатор причинной или или значимо предшествующей записи, тему или задачу которой продолжает данная запись'
			,-hide=>$w->tfoHide('id_')
			,-hide=>sub{ !$_ && ($_[2] !~/e/)}
			}
		,{-fld=>'puser'
			,-flg=>'euq'
			,-lbl=>'User', -cmt=>'Principal User of Request'
			,-lbl_ru=>'Польз.', -cmt_ru=>'Обслуживаемый пользователь или инициатор заявки; обычно имя пользователя в системе/сети; может просматривать запись'
			,-ddlb=>sub{$_[0]->uglist('-u',{})}
			,-ddlbtgt=>[undef,['auser'],['mailto',undef,',']]
			,-inp=>{-maxlength=>60}
			,-fdprop=>'nowrap=true'
			}, ''
		,{-fld=>'prole'
			,-flg=>'euq'
			,-lbl=>'UsrDev', -cmt=>'Division, Role or Group of User'
			,-lbl_ru=>'Подр.Плз', -cmt_ru=>'Обслуживаемое (или инициировавшее заявку) подразделение (в которое входит обслуживаемый пользователь); обычно имя группы в системе/сети; может просматривать запись'
			,-ddlb=>sub{$_[0]->uglist('-g',{})}
			,-ddlb=>sub{$_[0]->uglist('-g', $_[0]->{-pdta}->{'puser'}, {})}
			,-ddlbtgt=>[undef,['arole'],['rrole']]
			,-inp=>{-maxlength=>60}
			,-colspan=>3
			}
		,{-fld=>'auser'
			,-flg=>'euq'
			,-lbl_ru=>'Исп-ль', -cmt_ru=>'Исполнитель работ (записи) - Диспетчер, Инженер, Аналитик; имя пользователя в системе/сети; может изменять запись'
			,-ddlb=>sub{$_[0]->uglist('-u',{})}
			,-ddlbtgt=>[undef,['puser'],['mailto',undef,',']]
			,-fdprop=>'nowrap=true'
			}, ''
		,{-fld=>'arole'
			,-flg=>'euq'
			,-lbl_ru=>'Подр.Исп', -cmt_ru=>'Исполнители работ (записи) - Подразделение, роль или группа; имя глобальной группы в системе/сети; может изменять запись'
			,$w->{-a_cmdbh_larole}
			? (-inp=>{-labels=>$w->{-a_cmdbh_larole}})
			: (-ddlb=>sub{$_[0]->uglist('-g', $_[0]->{-pdta}->{'auser'}, {})})
			,!$w->{-a_cmdbh_vmrole} ? (-colspan=>3) : ()
			}, ''
		,{-fld=>'mrole'
			,-flg=>'euq'
			,-hide=>sub{!$_[0]->{-a_cmdbh_vmrole}
				|| ($_[3]->{record} 
					&& exists($_[0]->{-a_cmdbh_vmrole}->{$_[3]->{record}})
					&& !$_[0]->{-a_cmdbh_vmrole}->{$_[3]->{record}})
				|| (!$_ && ($_[2] !~/e/))
				}
			,$w->{-a_cmdbh_lmrole}
			? (-inp=>{-labels=>
				sub {	$_[0]->{-a_cmdbh_vmrole}
					&& $_[0]->{-pcmd}->{-edit}
					&& $_[0]->{-pout}->{record}
					&& ref($_[0]->{-a_cmdbh_vmrole}->{$_[0]->{-pout}->{record}})
					? $_[0]->{-a_cmdbh_vmrole}->{$_[0]->{-pout}->{record}}
					: $_[0]->{-a_cmdbh_lmrole}
				}
				,-loop=>1})
			: (-ddlb=>sub{$_[0]->uglist('-ug',{})}
				,-ddlbtgt=>[undef,['auser'],['puser'],['mailto',undef,',']])
			}
		,{-fld=>'vauser'
			,-flg=>'-', -hidel=>1
			,-expr=>"CONCAT_WS('; ', hdesk.auser, hdesk.arole)"
			,-lbl=>'Actors', -cmt=>'Actors of record - Actor and ARole'
			,-lbl_ru=>'Исп-ли', -cmt_ru=>'Исполнители записи - пользователь / подразделение; используется для представлений'
			,-ldstyle=>'padding-left: 1em'
			,-ldprop=>'nowrap=true'
			,-lsthtml=>sub{	my ($u, $g) =(split /\s*;\s*/, $_);
					my ($u1, $g1) =($u && $_[0]->udispq($u)
						,$g && $_[0]->{-a_cmdbh_larole} && $_[0]->{-a_cmdbh_larole}->{$g} ||$g);
					'<span title="' .$_[0]->htmlEscape(join('; ', $u ? "$u1 <$u>" : (), $g ? "$g1 <$g>" : ()))
					.'">'
					.$_[0]->htmlEscape(join('; '
						, $u
						? (($u1=~/[.,]/) ||($_[0]->{-lang} !~/ru/i)
							? $u1
							: $u1 =~/^([^\s]+)\s+([^\s]+)\s+([^\s]+)$/
							? $1 .' ' .substr($2,0,1) .'.' .substr($3,0,1) .'.'
							: $u1
							)
						: ()
						, $g ? $g1 : ()
						))
					.'</span>'}
			}
		,{-fld=>'rrole'
			,-flg=>'euq'
			,-lbl_ru=>'Читатели', -cmt_ru=>'Круг читателей записи - роль или группа; имя группы в системе/сети; может просматривать запись'
			,$w->{-a_cmdbh_lrrole}
			? (-inp=>{-labels=>$w->{-a_cmdbh_lrrole}})
			: (-ddlb=>sub{$_[0]->uglist('-g',{})})
			 },''
		 ,{-fld=>'mailto'
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist('-u',{})}
			,-ddlbtgt=>[[undef,undef,',']]
			,-ddlbmsab=>1
			,-inp=>{-maxlength=>255, -asize=>20}
			,-colspan=>3
			 }
		,{-fld=>'record'
			,-flg=>'euq', -null=>undef
			,-cmt=>"Record type:\n"
				."'request' general - registration/fulfillment;\n"
				."'work' free assignment with 'AboveID', 'Actors', 'Delete' restricted;\n"
				."'task' strict assignment with most fields and deletion resticted;\n"
				."'note' general - description/documentation;\n"
				."Incident Managenent: 'incident', 'unavailability';\n"
				."Problem Management: 'problem', 'solutuion', 'error';\n"
				."Change Management: 'change', 'unavailability';\n"
				."Asset Management: 'purchase'"
			,-cmt_ru=>"Тип записи:\n"
				."'заявка' - общего характера - регистрация/выполнение;\n"
				."'работа' - свободное назначение с ограничением изменения 'Главная' и 'Подр.Исп', удаления;\n"
				."'задание' - строгое назначение с ограничением изменения большинства полей и удаления;\n"
				."'заметка' - общего характера описание/документация;\n"
				."Управление Инцидентами: 'инцидент', 'недоступность';\n"
				."Управление Проблемами: 'проблема', 'решение', 'ошибка';\n"
				."Управление Изменениями: 'изменение', 'недоступность';\n"
				."Управление Активами: 'приобретение'"
			,-inp=>{-values=>[qw(request work task note analysis)]
				,-values=>[qw(request work task incident problem solutuion error change unavlbl purchase note analysis)]
				,-labels=>{	''=>''
						,'request'	=>'request'
						,'work'		=>'work'
						,'task'		=>'task'
						,'incident'	=>'incident'
						,'problem'	=>'problem'
						,'solutuion'	=>'solutuion'
						,'error'	=>'error'
						,'change'	=>'change'
						,'unavlbl'	=>'unavlbl'
						,'purchase'	=>'purchase'
						,'note'		=>'note'
					}
				,-labels_ru=>{	''=>''
						,'request'	=>'заявка'
						,'work'		=>'работа'
						,'task'		=>'задание'
						,'incident'	=>'инцидент'
						,'problem'	=>'проблема'
						,'solutuion'	=>'решение'
						,'error'	=>'ошибка'
						,'change'	=>'изменение'
						,'unavlbl'	=>'недоступн'
						,'purchase'	=>'приобретение'
						,'note'		=>'заметка'
					}
				,-loop=>1
				}
			}, ''
		,{-fld=>'rectype'
			,-flg=>'euq'
			,-lbl=>'Subtype', -cmt=>"Record subtype"
			,-lbl=>'Подтип', -cmt_ru=>"Подтип записи"
			,-hidel=>sub{!$_[0]->{-pout}->{record} || !$_[0]->{-a_cmdbh_rectype}->{$_[0]->{-pout}->{record}}
					|| (!$_ && ($_[2] !~/e/))}
			,-inp=>{ -values =>sub{	$_[0]->{-pout}->{record}
						&& $_[0]->{-a_cmdbh_rectype}->{$_[0]->{-pout}->{record}}
						|| []}
				,-labels =>{	''=>''
						,'svc-rst'	=>'service restore'
						,'svc-req'	=>'service request'
						,'sys-rst'	=>'system restore'
						,'sys-evt'	=>'system event'
						,'contact'	=>'contact'
						,'vendor'	=>'vendor'
						,'faq'		=>'FAQ'
						,'howto'	=>'HOWTO'
						,'bug'		=>'bug'
						,'enhancmnt'	=>'enhancement'
						,'part-schd'	=>'partial/scheduled'
						,'full-schd'	=>'full/scheduled'
						,'part-uschd'	=>'partial/unscheduled'
						,'full-uschd'	=>'full/unscheduled'
						,'change'	=>'change'
						,'project'	=>'project'
						,'release'	=>'release'
					}
				,-labels_ru =>{	''=>''
						,'svc-rst'	=>'восст.услуг'
						,'svc-req'	=>'обсл.польз.'
						,'sys-rst'	=>'восст.систем'
						,'sys-evt'	=>'событие сист'
						,'contact'	=>'контакт'
						,'vendor'	=>'поставщик'
						,'faq'		=>'чаво'
						,'howto'	=>'как'
						,'bug'		=>'дефект'
						,'enhancmnt'	=>'расширение'
						,'part-schd'	=>'част/план'
						,'full-schd'	=>'полн/план'
						,'part-uschd'	=>'част/непл'
						,'full-uschd'	=>'полн/непл'
						,'change'	=>'изменение'
						,'project'	=>'проект'
						,'release'	=>'релиз'
					}
				}
			}, ''
		,{-fld=>'recprc'
			,-flg=>'f', -hidel=>1
			,-lbl=>'OverType', -cmt=>"Master record type"
			,-lbl=>'Надтип', -cmt_ru=>"Тип вышестоящей записи"
			}, ''
		,{-fld=>'vrecord'
			,-flg=>'-', -hidel=>1
			,-lbl=>'Type', -cmt=>"Record subtype/type, for lists"
			,-lbl=>'Тип', -cmt_ru=>"Подтип/тип записи, для представлений"
			,-expr=>"IF(hdesk.rectype, hdesk.rectype, hdesk.record)"
			,-lsthtml=>sub{	$_[3]->{-a_rr} =$_[0]->lngslot($_[0]->{-table}->{hdesk}->{-mdefld}->{record}->{-inp},'-labels')	  if !$_[3]->{-a_rr};
					$_[3]->{-a_rt} =$_[0]->lngslot($_[0]->{-table}->{hdesk}->{-mdefld}->{rectype}->{-inp},'-labels')  if !$_[3]->{-a_rt};
					$_[3]->{-a_rs} =$_[0]->lngslot($_[0]->{-table}->{hdesk}->{-mdefld}->{severity}->{-inp},'-labels') if !$_[3]->{-a_rs};
					'<span title="'
					.$_[0]->htmlEscape(
						join(', ',$_[3]->{-rec}->{recprc} ? $_[3]->{-a_rr}->{$_[3]->{-rec}->{recprc}} ||$_[3]->{-rec}->{recprc} : ()
							, $_[3]->{-rec}->{record} ? $_[3]->{-a_rr}->{$_[3]->{-rec}->{record}} ||$_[3]->{-rec}->{record} : 'undef'
							, defined($_[3]->{-rec}->{severity}) ? $_[3]->{-a_rs}->{$_[3]->{-rec}->{severity}} ||$_[3]->{-rec}->{severity} : ()
						))
					.'">'
					.$_[0]->htmlEscape(
						$_[3]->{-a_rt}->{$_||''} ||$_[3]->{-a_rr}->{$_||''} ||$_ ||'undef'
					) .'</span>'}
			}, '', ''
		,{-fld=>'severity'
			,-flg=>'euq', -null=>undef
			,-lbl=>'Severity', -cmt=>"Severity of Record, level of urgency/impact: 'critical/wide'(0), 'high/large'(1), 'medium/limited'(2), 'low/localised'(3), 'general/planning'(4)"
			,-lbl_ru=>'Уровень', -cmt_ru=>"Приоритет записи, уровень срочности/воздействия: 'критический/расширенный'(0), 'высокий/значительный'(1), 'средний/ограниченный'(2), 'низкий/локальный'(3), 'общий/планирование'(4)"
			,-inp=>{-values=>[0,1,2,3,4]
				,-labels=>{	''=>''
						,0=>'critical (1h)'
						,1=>'high (8h)'		# major
						,2=>'medium (24h)'	# minor
						,3=>'low (48h)'		# warning
						,'3.5'=>'unavlbl'
						,4=>'general'}		# normal
				,-labels_ru=>{	''=>''
						,0=>'критический (1ч)'
						,1=>'значительный (8ч)'
						,2=>'средний (24ч)'	# незначительный
						,3=>'низкий (48ч)'	# предупреждение
						,'3.5'=>'недоступн'
						,4=>'общий'}		# нормальный
				,-loop=>sub{!$_[0]->{-pdta}->{etime}
					&& (($_[0]->{-pdta}->{record}||'') eq 'incident')
					}
				}
			}
		,{-fld=>$w->tn('-rvcState')
			,-flg=>'euq', -null=>undef
			,-cmt=>"Status of the record or activity: planning ('draft', 'do') --> progress ('progress','rollback','edit','delay') --> result ('ok', 'no') --> approvement ('ok-appr','no-appr').\n"
				."'Actors' operates the record ('progress','edit','delay', 'ok', 'no').\n"
				."'Managers' are responsible for planning ('draft', 'do'), approvement ('ok-appr','no-appr') and moderation; the record may be offered for 'Managers' ('draft', 'do')."
			,-cmt_ru=>"Статус записи/деятельности: планирование ('набросок', 'выполнить') --> состояние работ ('выполнение','возврат','редактирование','задержка') --> результат ('завершено', 'отклонено') --> одобрение ('утверждено','утверждено отклоненение').\n"
				."'Исполнители' сопровождают запись ('выполнение','редактирование','задержка', 'завершено', 'отклонено').\n"
				."'Менеджеры' выполняют планирование ('набросок', 'выполнить') и одобрение ('утверждено','утверждено отклоненение'), модерируют сопровождение записи; запись может быть предложена 'Менеджерам' ('набросок', 'выполнить')."
			,-inp=>{-values=>[qw(draft do progress rollback edit delay ok no ok-appr no-appr deleted)]
				,-labels_ru=>{	''=>''
						,'draft'=>'набросок'
						,'do'=>'выполнить'
						,'progress'=>'выполн-е'
						,'rollback'=>'возврат'
						,'edit'=>'редакт-е'
						,'delay'=>'задержка'
						,'ok'=>'завершено'
						,'no'=>'отклонено'
						,'ok-appr'=>'утверждено'
						,'no-appr'=>'утв-откл'
						,'deleted'=>'удалено'}
				}
			,-lhstyle=>'width: 5ex'
			,-ldprop=>'nowrap=true'
			,-ldstyle=>sub{	my ($v,$r) =($_, $_[3]->{-rec});
				#	if (0 && !$r->{-a_sg}) { # bg highlight
				#		$r->{-a_sg} ={};
				#		my $h =$_[0]->recSel(
				#		-table=>'hdesk'
				#		,-data=>['idrm','status']
				#		,-group=>['idrm','status']
				#		,-where=>"status IN('draft','do','progress','rollback','delay','edit') AND (idrm IS NOT NULL AND idrm<>'')");
				#		while(my $t=$h->fetchrow_hashref()) {
				#			$r->{-a_sg}->{$t->{idrm}} =''
				#				if !$r->{-a_sg}->{$t->{idrm}};
				#			$r->{-a_sg}->{$t->{idrm}} .=' ' .$t->{status}
				#		}
				#	}
				#	elsif ($r->{votimej} && $r->{utime} && $r->{status}
				#	&& ($r->{status} =~/^(?:draft|do|progress|rollback|delay|edit)/)
				#	&& ($r->{utime} lt substr($r->{votimej},-length($r->{utime})))
				#		) {
				#		$h =1;
				#	}
					$r->{-a_st} =$_[0]->strtime() if !$r->{-a_st};
					($v =~/^(?:ok|ok-appr)$/
					? '' 
					: $v 
					&& ($v=~/^(?:do|progress|rollback|delay|edit)$/)
					&& $r->{etime}
					&& ($r->{-a_st} gt $r->{etime})
					? 'color: red; font-weight: bold;'
					: 'color: brown; font-weight: bold')
					.($v
					&& ($v =~/^(?:draft|do|progress|rollback|delay|edit)$/)
					&& $r->{-a_sg} && !$r->{-a_sg}->{$r->{id}}
					? '; background-color: yellow'
					: '')}
			}, ''
		,{-fld=>'stime'
			,-flg=>'euq'
			,-lbl=>'Start', -cmt=>'Start time of record described by'
			,-lbl_ru=>'Начало', -cmt_ru=>'Дата и время начала описываемого записью'
			,-inp=>{-maxlength=>20}
			,-fdprop=>'nowrap=true'
			,-ldstyle=>$w->{-a_cmdbh_fsvrlds}
			,-ldprop=>'nowrap=true'
			,-lsthtml=>sub{/(?::00|\s00:00:00|:\d\d)$/ ? $` : $_}
			 }, ''
		,{-fld=>'etime'
			,-flg=>'euq'
			,-lbl=>'End', -cmt=>'End time of record described by'
			,-lbl_ru=>'Заверш', -cmt_ru=>'Дата и время завершения описываемого записью'
			,-inp=>{-maxlength=>20}
			,-fdprop=>'nowrap=true'
			,-ldstyle=>$w->{-a_cmdbh_fsvrlds}
			,-ldprop=>'nowrap=true'
			,-lsthtml=>sub{/(?::00|\s00:00:00|:\d\d)$/ ? $` : $_}
			 }
		,{-fld=>'object'
			,-flg=>'euq'
			,-cmt=>'Object (computer, device) of record described by'
			,-cmt_ru=>'Уникальное имя объекта записи - компьютера или устройства, согласно DNS'
			,-ddlb =>sub{$_[0]->cgiQueryFv('','object')}
			,-ddlb =>sub{$_[0]->recUnion(
					 $_[0]->cgiQueryFv('','object')
					,$_[0]->recSel(-table=>'cmdbm',-data=>['name'],-key=>{'record'=>'computer'},-order=>'name')
					)}
			,-form=>'hdesk'
			,-inp=>{-maxlength=>60}
			,-fnhref=>sub{
				$_
				? $_[0]->urlCmd('',-form=>'cmdbm',-key=>{'name'=>$_},-cmd=>'recRead')
				: $_[2] =~/e/
				? $_[0]->urlCmd('',-form=>'cmdbmn',-key=>{'record'=>'computer'},-cmd=>'recList')
				: ''}
			},''
		,{-fld=>'application'
			,-flg=>'euq'
			,-lbl=>'Application', -cmt=>'Application or Resource (system, service, application) related to Record/Object'
			,-lbl_ru=>'Ресурс', -cmt_ru=>'Ресурс или приложение (система, компонент, сервис, приложение), к которому относится запись, в формате \'система/подсистема/...\''
			#,-ddlb =>sub{$_[0]->cgiQueryFv('','application')}
			,-ddlb =>sub{$_[0]->recUnion(
					 $_[0]->cgiQueryFv('','application')
					,$_[0]->recSel(-table=>'cmdbm',-data=>['name'],-key=>{'record'=>'service'},-order=>'name')
					)}
			,-form=>'hdesk'
			,-inp=>{-maxlength=>60}
			,-fnhref=>sub{
				$_
				? $_[0]->urlCmd('',-form=>'cmdbm',-key=>{'name'=>$_},-cmd=>'recRead')
				: $_[2] =~/e/
				? $_[0]->urlCmd('',-form=>'cmdbmn',-key=>{'record'=>'service'},-cmd=>'recList')
				: ''}
			},''
		,{-fld=>'location'
			,-flg=>'euq', -hidel=>sub{!$_ && ($_[2] !~/e/)}
			,-lbl=>'Loc.', -cmt=>'Location of Record/Object'
			,-lbl_ru=>'Место', -cmt_ru=>'Местонахождение/размещение, к которому относится запись, в формате \'организация/.../кабинет\''
			,-ddlb =>sub{$_[0]->cgiQueryFv('','location')}
			,-ddlb =>sub{$_[0]->recUnion(
					 $_[0]->cgiQueryFv('','location')
					,$_[0]->recSel(-table=>'cmdbm',-data=>['name'],-key=>{'system'=>['Locations','Местонахождения']},-order=>'name')
					)}
			,-form=>'hdesk'
			,-inp=>{-maxlength=>60}
			,-fnhref=>sub{$_ && $_[0]->urlCmd('',-form=>'cmdbm',-key=>{'name'=>$_},-cmd=>'recRead')}
			,-fnhref=>sub{
				$_
				? $_[0]->urlCmd('',-form=>'cmdbm',-key=>{'name'=>$_},-cmd=>'recRead')
				: $_[2] =~/e/
				? $_[0]->urlCmd('',-form=>'cmdbmn',-key=>{'system'=>['Locations','Местонахождения']},-cmd=>'recList')
				: ''}
			}
		,"\n"
		,{-fld=>'cause', -hide=>sub{$_[2] =~/e/
					? !$_ && (($_[0]->{-pout}->{record}||'') !~/^(?:incident|problem|error)/)
					: !$_}
			,-flg=>'euq'
			,-lbl=>'Cause', -cmt=>'Cause of incident, root cause of problem ivestigation or known error'
			,-lbl_ru=>'Причина', -cmt_ru=>'Причина инцидента, корневая причина проблемы или ошибки'
			,-form=>'hdesk'
			#,-ddlb =>sub{$_[0]->cgiQueryFv('','cause')}
			#,-inp=>{-maxlength=>60}
			,-inp=>{ -values =>[''
					,'fail'
					,'fail/software'
					,'fail/hardware'
					,'fail/network'
					,'breakage'
					,'breakage/software'
					,'breakage/hardware'
					,'breakage/network'
					,'improper'
					,'improper/software'
					,'improper/hardware'
					,'improper/configuration'
					,'change'
					,'organization'
					,'personnel']
				,-labels_ru =>{''	=>''
					,'fail'	=>'сбой'
					,'fail/software'	=>'сбой прогр'
					,'fail/hardware'	=>'сбой оборуд'
					,'fail/network'	=>'сбой сети'
					,'breakage'	=>'поломка'
					,'breakage/software'	=>'поломка прогр'
					,'breakage/hardware'	=>'поломка оборуд'
					,'breakage/network'	=>'поломка сети'
					,'improper'	=>'некорректность'
					,'improper/software'	=>'неверна прогр'
					,'improper/hardware'	=>'неверно оборуд'
					,'improper/configuration'=>'неверна конфиг'
					,'change'	=>'изменение'
					,'organization'	=>'организация'
					,'personnel'	=>'персонал'}
				}
			},''
		,{-fld=>'process'
			,-flg=>'euq', -hide=>sub{!$_ && ($_[2] !~/e/)}
			,-lbl=>'Process', -cmt=>'Operation, process, item of expenses'
			,-lbl_ru=>'Процесс', -cmt_ru=>'Действие, процесс, статья расходов'
			,-ddlb =>sub{$_[0]->cgiQueryFv('','process')}
			,-form=>'hdesk'
			,-inp=>{-maxlength=>80}
			,-fnhref=>sub{
				$_
				? $_[0]->urlCmd('',-form=>'cmdbm',-key=>{'name'=>$_},-cmd=>'recRead')
				: $_[2] =~/e/
				? $_[0]->urlCmd('',-form=>'cmdbmh',-cmd=>'recList')
				: ''}
			},''
		,{-fld=>'cost'
			,-flg=>'euq', -hide=>sub{!$_ && ($_[2] !~/e/)}
			,-lbl=>'Cost', -cmt=>'Cost of the Record described by, man*hour'
			,-lbl_ru=>'Затраты', -cmt_ru=>'Затраты на выполнение работ, чел.*час'
			,-inp=>{-maxlength=>10}
			}
		,{-fld=>'subject'
			,-flg=>'euqm', -null=>undef
			,-lbl=>'Description', -cmt=>'A brief description, summary, subject or title'
			,-lbl_ru=>'Описание', -cmt_ru=>'Краткое описание заявки, событий или работ; тема или заглавие записи'
			,-fnhref=>sub{
				(($_[0]->{-pout}->{record} && ($_[0]->{-pout}->{record} =~/^(?:incident|error|solutuion)/))
				||($_[0]->{-pout}->{recprc} && ($_[0]->{-pout}->{recprc} =~/^(?:incident|error|solutuion)/)))
				&& $_[0]->urlCmd('',-form=>'hdesk'
					,-qwhere=>
					($_[0]->{-pout}->{object} ||$_[0]->{-pout}->{application} ||$_[0]->{-pout}->{location}
					 ? "hdesk.record IN('incident','error','solution') AND ("
						.join(' OR '
						  , map {$_[0]->{-pout}->{$_}
							? 'hdesk.' .$_ .'=' .$_[0]->dbi->quote($_[0]->{-pout}->{$_})
							: ()} qw (object application location))
						.")"
					 : "hdesk.record IN('error','solution')")
					,-qorder=>'hdesk.subject asc'
					)}
			,-inp=>{-asize=>89, -maxlength=>255}
			,-colspan=>10
			}
		,{-fld=>'vsubject'
			,-flg=>'-', -hidel=>1
			,-expr=>"CONCAT_WS('. ', hdesk.object, hdesk.application, hdesk.location, hdesk.subject)"
			,-lbl=>'Description', -cmt=>'Description following Object and Resource, for lists'
			,-lbl_ru=>'Описание', -cmt_ru=>'Объект. Ресурс. Место. Описание. Используется для представлений'
			}
		,{-fld=>'vsubjectx'
			,-flg=>'-', -hidel=>1
			,-expr=>"CONCAT_WS('. ', hdesk.object, hdesk.application, hdesk.location, hdesk.subject)"
			,-lbl=>'Description', -cmt=>'Description following Object and Resource, for lists'
			,-lbl_ru=>'Описание', -cmt_ru=>'Объект. Ресурс. Место. Описание. Используется для представлений'
			,-lsthtml=>sub{	my $v =$_[3]->{-rec}->{'comment'};
					my $a;
					if (($_[3]->{-rec}->{'record'}||'') !~/^(?:work|task)$/) {
						$v =undef;
						$a =2
					}
					elsif (!$v) {}
					elsif ($_[0]->ishtml($v)) {
						$v =undef;
						$a =1
					}
					else {
						# $a =length($v) >1024;
						# $v =substr($v, 0, 1024) if $a;
						my($i,$j,$k) =(0,0,0);
						while (length($v) >$j +1) {
							$i =index($v,"\n",$j);
							$j =	$i > $j +79
								? $j +80
								: $i <0
								? $j +80
								: $i +1;
							if (++$k >=15) {
								$a =1;
								$v =substr($v,0,$j);
								$v =$` if $v =~/\s+$/;
								last
							}
						}
						$v =$_[0]->htmlFVUT('hdesk',$_[3]->{-rec},$v)
					}
					$a =$a && $_[0]->urlCmd('',-cmd=>'recRead',-form=>'hdesk',-key=>$_[3]->{-rec}->{'id'});
					$_[0]->htmlEscape($_)
					.($v ? '<div style="padding-top: 0.5ex;"><span style="font-size: smaller;">' .$v .'</span>' : '')
					.($a ? '&nbsp;<a href="' .$a .'" style="text-decoration: none; font-weight: bold;" nowrap=true>&gt;&gt;</a>' : '')
					.($v ? '</div>' : '')
					}
			}
		,{-fld=>'vcount'
			,-flg=>'-', -hidel=>1
			,-expr=>"COUNT(*)"
			,-lbl=>'Number', -cmt=>'Number of records, for lists'
			,-lbl_ru=>'Количество', -cmt_ru=>'Число записей, для представлений'
			}
		,{-fld=>'vdefinition'
			,-flg=>'-', -hidel=>1
			,-expr=>"cmdbm.definition"
			,-lbl=>'Defiition', -cmt=>'CMDB definition, for lists'
			,-lbl_ru=>'Определение', -cmt_ru=>'Определение из КБД, для представлений'
			}
		,"\f"
		,{-fld=>'comment'
			,-flg=>'eu'
			,-lbl=>'Notes', -cmt=>"Comment text or HTML. Special URL protocols: 'urlh://' (this host), 'urlr://' (this application), 'urlf://' (file attachments), 'key://' (record id or table//id), 'wikn://' (wikiname). Bracket URL notations: [[xxx://...]], [[xxx://...][label]], [[xxx://...|label]]"
			,-lbl_ru=>'Информация', -cmt_ru=>"Подробное описание заявки, событий или работ, текст комментария. Гиперссылки могут быть начаты с 'urlh://' (компьютер), 'urlr://' (это приложение), 'urlf://' (присоединенные файлы), 'key://' (ключ записи или таблица//ключ), 'wikn://' (имя записи); могут быть в скобочной записи [[xxx://...]], [[xxx://...][label]], [[xxx://...|label]]"
			,-lblhtml=>''
			,-inp=>{-htmlopt=>1,-hrefs=>1,-arows=>5,-cols=>70,-maxlength=>4*1024}
			}
		, $w->tfdRFD(), "\f"
		, $w->tfvVersions()
		, $w->tfvReferences(undef
			, sub{	1
				? (-datainc=>[qw(comment)],-display=>[qw(votime vrecord status vsubjectx vauser)])
				: ()
				})
		]
		,$w->ttoRVC()
		,-dbd		=>'dbi'
		,-ridRef	=>[qw(idrm idpr comment)]
		,-dbiACLike	=>'eq'
		,-racPrincipal	=>['puser', 'prole']
		,-racActor	=>['auser', 'arole']
		,-racManager	=>['mrole']
		,-racReader	=>[qw(auser arole puser prole rrole), $w->tn('-rvcUpdBy'), $w->tn('-rvcInsBy')]
		,-racWriter	=>[$w->tn('-rvcUpdBy'), 'auser', 'arole', 'mrole']
		,-urm		=>[$w->tn('-rvcUpdWhen')]
		,-rvcAllState	=>['draft','do','progress','rollback','delay','chk-out','edit','ok','no','ok-appr','no-appr','deleted']
		,-rvcFinState	=>['status'=>'ok','no','ok-appr','no-appr','deleted']
		,-rvcChgState	=>[$w->tn('-rvcState')=>'draft','edit']
		,-rfa		=>1
		,-cgiRun0A	=>sub{	$_[0]->{-udisp} ='+'
					# comments as group display names
					}
		,-recNew0C	=>sub{
			$_[2]->{'idrm'}   =$_[3]->{'id'}
					if !$_[2]->{'idrm'} && $_[3]->{'id'};
			$_[2]->{'record'} ='work'
					if !$_[2]->{'record'} && $_[2]->{'idrm'};
			foreach my $n (qw(puser prole rrole)) {
				$_[2]->{$n} =$_[3]->{$n} 
					if !$_[2]->{$n} && $_[3]->{$n};
			}
			foreach my $n (qw(severity object application location process subject comment)) {
				$_[2]->{$n} =$_[3]->{$n} 
					if !$_[2]->{$n} && defined($_[3]->{$n}) && ($_[3]->{$n} ne '');
			}
			foreach my $n (qw(puser auser)) {
				$_[2]->{$n} =$_[2]->{'uuser'} ||$_[0]->user
					if !$_[2]->{$n};
			}
			$_[2]->{'mrole'} =$_[3]->{'arole'}
					if !$_[2]->{'mrole'} && $_[3]->{'arole'};
			$_[2]->{'etime'} =$_[3]->{'etime'} 
					if !$_[2]->{'etime'} && $_[3]->{'etime'}
					&& $_[3]->{'etime'} gt $_[0]->strtime();
			$_[0]->recLast($_[1],$_[2],['auser'],['rrole'])
				if !$_[2]->{'rrole'};	# ??? 'Users'
			$_[2]->{'record'} ='request'
				if !$_[2]->{'record'};
			$_[2]->{'severity'} ='4'
				if !defined($_[2]->{'severity'});
			$_[2]->{'status'} ='do'
				if !$_[2]->{'status'};
			}
		,-recEdt0A	=> sub{
				if (	$_[1]->{-cmd} eq 'recNew'
				||	$_[2]->{'puser__L'}
				||	$_[2]->{'auser__L'}) {
					$_[0]->recLast($_[1],$_[2],['puser'],['prole']);
					$_[0]->recLast($_[1],$_[2],['auser'],['arole']);
					$_[2]->{'prole'} =undef 
						if $_[2]->{'prole'}
						&& !grep {lc($_) eq lc($_[2]->{'prole'})
							} @{$_[0]->ugroups($_[2]->{'puser'})};
					$_[2]->{'arole'} =undef 
						if $_[2]->{'arole'}
						&& !grep {lc($_) eq lc($_[2]->{'arole'})
							} @{$_[0]->ugroups($_[2]->{'auser'})};
				}
				if (	$_[1]->{-cmd} eq 'recNew'
				||	$_[2]->{'object__L'}) {
					$_[2]->{object}
					&& $_[0]->recLast($_[1],$_[2],['object','arole'],['application','location']);
				}
				if (	$_[1]->{-cmd} eq 'recNew'
				||	$_[2]->{'object__L'}
				||	$_[2]->{'application__L'}) {
					($_[2]->{object} ||$_[2]->{application})
					&& $_[0]->recLast($_[1],$_[2],['object','application','arole'],['process']);
				}
			}
		,-recFlim0R	=>sub{
			$_[0]->logRec('recFlim0R',$_[1]->{-cmd}
				, map {($_, $_[0]->recActor(@_[1..3],$_))
					} qw(-racOwner -racReader -racWriter -racActor -racManager -racPrincipal));

			return(0) if !$_[0]->{-a_cmdbh_vmrole};

			$_[2]			# Types of weak record
			&& $_[1]->{-edit}
			&& $_[2]->{-editable}
			&& !$_[2]->{idrm}
			&& $_[0]->recActLim(@_[1..3]
				,[grep {$_ !~/^(?:task|work)$/
					} @{$_[1]->{-cmdt}->{-mdefld}->{record}->{-inp}->{-values}}]
				,'record');

			$_[0]->uadmin()		# States of record
			? 1
			: !$_[1]->{-edit} || !($_[2] ? $_[2]->{-editable} : 1)
			? 1
			: ($_[3]
				? ($_[3]->{mrole} && !(exists($_[0]->{-a_cmdbh_vmrole}->{$_[3]->{record}}) && !$_[0]->{-a_cmdbh_vmrole}->{$_[3]->{record}}))
				: ($_[2]->{mrole} && !(exists($_[0]->{-a_cmdbh_vmrole}->{$_[2]->{record}}) && !$_[0]->{-a_cmdbh_vmrole}->{$_[2]->{record}})))
			? $_[0]->recActLim(@_[1..3]
				,[!$_[3]
				? ( $_[0]->recActor(@_[1..3],'-racManager')
				  ? qw(draft do progress rollback edit delay ok no ok-appr no-appr)
				  : $_[0]->recActor(@_[1..3],'-racActor')
				  ? qw(draft do progress rollback edit delay ok no)
				  : qw(draft do))
				: $_[0]->recActor(@_[1..3],'-racManager')
					&& $_[0]->recActor(@_[1..3],'-racActor')
				? ( $_[3]->{status} =~/^(?:draft)$/
				  ? qw(draft do progress rollback edit delay ok no ok-appr no-appr deleted)
				  : $_[3]->{status} =~/^(?:do)$/
				  ? qw(do progress rollback edit delay ok no ok-appr no-appr deleted)
				  : $_[3]->{status} =~/^(?:progress|rollback|edit|delay|ok|no)$/
				  ? qw(progress rollback edit delay ok no ok-appr no-appr deleted)
				  : $_[3]->{status}
				  )
				: $_[3]->{status} =~/^(?:draft)$/
				? ($_[0]->recActor(@_[1..3],'-racManager')
					? qw(draft do progress rollback edit delay ok no ok-appr no-appr deleted)
					: $_[3]->{status})
				: $_[3]->{status} =~/^(?:do)$/
				? ($_[0]->recActor(@_[1..3],'-racManager')
					? qw(do progress rollback edit delay ok no ok-appr no-appr)
					: qw(do progress rollback edit delay ok no))
				: $_[3]->{status} =~/^(?:progress|rollback|edit|delay)$/
				? ($_[0]->recActor(@_[1..3],'-racManager')
					? qw(progress rollback edit delay ok no ok-appr no-appr)
					: qw(progress rollback edit delay ok no))
				: $_[3]->{status} =~/^(?:ok|no)$/
				? ($_[0]->recActor(@_[1..3],'-racManager')
					? qw(progress rollback edit delay ok no ok-appr no-appr)
					: qw(progress rollback edit delay ok no))
				: $_[3]->{status}
					]
				,'status')
			: $_[0]->recActLim(@_[1..3]
				,[qw(do progress rollback edit delay ok no deleted)]
				,'status');

			!$_[3]			# Access to record
			? 1
			: $_[0]->uadmin()
			? 1
			: $_[3]->{mrole} && !(exists($_[0]->{-a_cmdbh_vmrole}->{$_[3]->{record}}) && !$_[0]->{-a_cmdbh_vmrole}->{$_[3]->{record}})
			? (	$_[0]->recActor(@_[1..3],'-racOwner','-racManager')
				&& ($_[3]->{status} =~/^(?:draft|do)$/)
				? 1
				: $_[0]->recActor(@_[1..3],'-racManager')
				&& $_[0]->recActor(@_[1..3],'-racActor')
				? $_[0]->recActLim(@_[1..3],'v', qw(-recDel))
				: $_[0]->recActor(@_[1..3],'-racManager')
				? ( $_[3]->{status} =~/^(?:draft|do)$/
				  ? 1
				  : $_[3]->{status} =~/^(?:progress|rollback|edit|delay|ok|no)$/
				  ? ($_[0]->recActLim(@_[1..3],'v', qw(-recDel))
				  && $_[0]->recActLim(@_[1..3],'v!', qw(auser status etime cost status comment)))
				  : $_[0]->recActLim(@_[1..3],'-recRead')
				  )
				: $_[3]->{status} =~/^(?:progress|rollback|edit|delay|ok|no)$/
				? $_[0]->recActLim(@_[1..3],'v', qw(-recDel))
				&& $_[0]->recActLim(@_[1..3],'v!', qw(auser status cost comment))
				: $_[0]->recActLim(@_[1..3],'-recRead')
				)
			: $_[0]->recActor(@_[1..3],'-racOwner')
			? 1
			: !$_[3]->{idrm}
			? $_[0]->recActLim(@_[1..3],'v', qw(-recDel))
			: $_[3]->{record} eq 'work'
			? $_[0]->recActLim(@_[1..3],'v',qw(-recDel idrm arole record))
			: $_[3]->{record} eq 'task'
			? $_[0]->recActLim(@_[1..3],'v', qw(-recDel))
			&& $_[0]->recActLim(@_[1..3],'v!', qw(auser status cost comment))
			: $_[0]->recActLim(@_[1..3],'v', qw(-recDel));
			}
		,-recEdt0R	=> sub{
			$_[2]->{mrole} =$_[0]->{-a_cmdbh_vmrole}->{$_[2]->{record}}
				if $_[2]->{record}
				&& $_[0]->{-a_cmdbh_vmrole}
				&& exists($_[0]->{-a_cmdbh_vmrole}->{$_[2]->{record}})
				&& !ref($_[0]->{-a_cmdbh_vmrole}->{$_[2]->{record}})
				&& $_[0]->{-a_cmdbh_vmrole}->{$_[2]->{record}};
			delete $_[2]->{rectype}
				if $_[2]->{rectype} && $_[2]->{record}
				&& !(grep {$_ eq $_[2]->{rectype}
						} @{$_[0]->{-a_cmdbh_rectype}->{$_[2]->{record}}||[]});
			$_[2]->{stime} =$_[2]->{ctime} || $_[0]->strtime()
				if !$_[2]->{stime};
			$_[2]->{etime} =do {
				my $tl =$_[0]->lngslot($_[0]->{-table}->{hdesk}->{-mdefld}->{severity}->{-inp},'-labels');
				if ($tl && ($tl->{$_[2]->{severity}} =~/\(([\d:]+)/)) {
					$tl =$1;
					my $t0 =$_[0]->timestr($_[2]->{stime}) ||time();
					my @t0 =localtime($t0);
					my $t1 =$t0 +($tl =~/:(\d+)/ ? $1 * 60 : $tl *60*60);
					if (($tl =/^\d+$/) && ($tl >8)
					&& !(!$t0[6] ||($t0[6] ==6))) {
						my @t1 =localtime($t1);
						$t1 +=24*60*60 if !$t1[6];
						$t1 +=48*60*60 if  $t1[6] ==6;
					}
					$_[0]->strtime($t1);
				}
				else {
					$_[2]->{etime}
				}}
				if !$_[2]->{etime}
				&& $_[2]->{record}
				&& ($_[2]->{record} eq 'incident')
				&& defined($_[2]->{severity})
				&& ($_[2]->{severity} ne '4')
				&& ($_[2]->{$_[0]->tn('-rvcState')}
					=~/^(?:do|delay|progress|rollback)$/);
			$_[2]->{etime} =$_[2]->{utime}
				if !$_[2]->{etime}
				|| ($_[3] && $_[3]->{utime} && ($_[2]->{etime} eq $_[3]->{utime}));
			$_[2]->{stime} =(length($3) <3 ? "20$3" : $3) .'-' .$2 .'-' .$1 .$4
				if $_[2]->{stime} 
				&& $_[2]->{stime} =~/^(\d+)\.(\d+)\.(\d+)(.*)/;
			$_[2]->{etime} =(length($3) <3 ? "20$3" : $3) .'-' .$2 .'-' .$1 .$4
				if $_[2]->{etime} 
				&& $_[2]->{etime} =~/^(\d+)\.(\d+)\.(\d+)(.*)/;
			($_[2]->{etime}, $_[2]->{stime})
				= ($_[2]->{stime}, $_[2]->{etime})
				if $_[2]->{etime}
				&& $_[2]->{stime}
				&& ($_[2]->{stime} gt $_[2]->{etime});
			$_[2]->{etime} = $_[2]->{utime}
				if $_[2]->{etime}
				&& $_[2]->{utime}
				&& ($_[2]->{$_[0]->tn('-rvcState')} =~/^(?:ok|no)$/)
				&& ($_[2]->{utime} lt $_[2]->{etime});
			$_[2]->{mailto} =$_[0]->w32umail($_[2]->{mailto})
				if $_[2]->{mailto};
			if ($_[2]->{'process'} 
			&& !$_[0]->uadmin()
			&& !$_[0]->recLast($_[1],$_[2],['process'])) {
				$_[0]->die('Not configured process')
			}
			}
		,-recChg0R	=>sub {
			$_[2]->{mrole} =$_[0]->{-a_cmdbh_vmrole}->{$_[2]->{record}}
				if $_[2]->{record}
				&& $_[0]->{-a_cmdbh_vmrole}
				&& exists($_[0]->{-a_cmdbh_vmrole}->{$_[2]->{record}})
				&& !ref($_[0]->{-a_cmdbh_vmrole}->{$_[2]->{record}});
			if ($_[2] && $_[2]->{idrm}) {
				my $r =$_[0]->recSel(-table=>$_[1]->{-table},-key=>{'id'=>$_[2]->{idrm}});
				$r =$r->fetchrow_hashref();
				if (!$r) {
					$_[0]->warn("-recChg0R: recSel: parent not found\n")
				}
				else {
					$_[2]->{recprc} =$r->{record} =~/^(?:work|task)$/
							? $r->{recprc} ||$r->{record}
							: $r->{record};
					$_[0]->logRec('-recChg0R'
						,map {($_ => $_[2]->{$_})
							} qw (recprc))
				}
			}
			else {
				$_[2]->{recprc} =undef;
			}
			$_[0]->recUtr({-table=>$_[1]->{-table},-version=>1}
				,{recprc =>$_[2]->{record} =~/^(?:work|task)$/
					? $_[2]->{recprc} ||$_[2]->{record}
					: $_[2]->{record}}
				,{idrm =>$_[3]->{id}})
				if $_[3] && ($_[3]->{record} ne $_[2]->{record});
			}
		,-recChg0W	=>sub {
			$_[0]->smtpSend(-to=>$_[2]->{mailto}
				,-pout=>$_[2], -pcmd=>$_[1])
				if $_[2]->{mailto}
				&& ($_[2]->{$_[0]->tn('-rvcState')}
					=~/^(?:ok|no|ok-appr|no-appr|do|delay|progress|rollback|deleted)$/);

			}
		,-query		=>{	 -display=>[qw(votime vrecord status vsubject vauser)]
					,-order=>'votime'
					,-keyord=>'-dall'
					,-frmLso=>'actors'
					}
		,-limit		=>256
		,-frmLsoAdd	=>[{-lbl=>'Today', -lbl_ru=>'Сегодня'
					,-cmd=>{-qwhere=>'TO_DAYS(hdesk.stime) <=TO_DAYS(NOW())'}
					}]
		,-frmLsc	=>
				[{-val=>'votime',-cmd=>{}}
				,{-val=>'votimeje',-lbl=>'Exec/under'
					,-lbl_ru=>'Вып-е/под', -cmd=>
					sub {
						$_[0]->{-pcmd}->{-qhref}=$_[0]->{-pcmd}->{-qhref}||$_[2]->{-qhref}||{};
						$_[0]->{-pcmd}->{-qhref}->{-urm} =['votimej'];
						$_[3]->{-order} ='votime';
						$_[3]->{-group} ='votime, hdesk.id';
						$_[3]->{-join}  =' LEFT OUTER JOIN cgibus.hdesk AS j ON (j.idrm=hdesk.id)';
						$_[3]->{-datainc}=[qw(votimej)]}}
				,{-val=>'votimej',-lbl=>'Upd/under'
					,-lbl_ru=>'Изм-е/под', -cmd=>
					sub {
						$_[0]->{-pcmd}->{-qhref}=$_[0]->{-pcmd}->{-qhref}||$_[2]->{-qhref}||{};
						$_[0]->{-pcmd}->{-qhref}->{-urm} =['votimej'];
						$_[3]->{-order} ='votimej';
						$_[3]->{-group} ='votime, hdesk.id';
						$_[3]->{-join}  =' LEFT OUTER JOIN cgibus.hdesk AS j ON (j.idrm=hdesk.id)';
						$_[3]->{-display}->[0] ='votimej'}}
				,{-val=>'vftime'}
				,{-val=>'stime'}
				,{-val=>'utime'}
				,{-val=>'ctime'}
				]
		,-frmLso1C	=>\&a_hdesk_stbar
	}
	});

$w->set(
   -form=>{
	 'default'	=>{-subst=>'start'}
	,$w->tvdIndex()
	,$w->tvdFTQuery()
	,'start'=>{
		 -lbl		=>'Start Page'
		,-cmt		=>'Service Desk and Configuretion Management Database'
		,-lbl_ru	=>'Стартовая страница'
		,-cmt_ru	=>'Центр обслуживания и Конфигурационная база данных'
		,-cgcCall	=>'cmdb-start.psp'
	}
				### cmdbm views
	,'cmdbmn' =>{
		 -lbl		=>'CMDB - Names'
		,-cmt		=>'CMDB - Named elements'
		,-lbl_ru	=>'КБД - Имена'
		,-cmt_ru	=>'КБД - Именованные элементы'
		,-table		=>'cmdbm'
		,-recQBF	=>'cmdbm'
		,-query		=>{-display	=>['name','record', 'status', 'utime', 'definition']
				  ,-where	=>"name IS NOT NULL AND name !=''"
				  ,-order	=>'name'
				  ,-keyord	=>'-aall'
					}
		,-limit		=>1024
		,-qhref		=>{-key=>['name'], -form=>'cmdbm', -cmd=>'recRead'}
		,-frmLsc	=>
				[{-val=>'alphabetically',-cmd=>{}}
				,['utime',undef, {-order=>'utime',-keyord=>'-dall'}]
				,['ctime',undef, {-order=>'ctime',-keyord=>'-dall'}]
				]
		}
	,'cmdbmh' =>{
		 -lbl		=>'CMDB - Hierarchy'
		,-cmt		=>'CMDB - Hierarchy of records'
		,-lbl_ru	=>'КБД - Иерархия'
		,-cmt_ru	=>'КБД - Иерархия записей'
		,-table		=>'cmdbm'
		,-recQBF	=>'cmdbm'
		,-query		=>{-display	=>['name','record', 'status', 'utime', 'definition']
				  ,-where	=>"(name IS NOT NULL AND name !='')"
				." AND (system IS NULL OR system='')"
				  ,-order	=>'name'
				  ,-keyord	=>'-aall'
					}
		,-limit		=>1024
		,-qhref		=>{-key=>['name'], -form=>'cmdbm', -cmd=>'recRead'}
		,-frmLsc	=>
				[{-val=>'alphabetically',-cmd=>{}}
				,['utime',undef, {-order=>'utime',-keyord=>'-dall'}]
				,['ctime',undef, {-order=>'ctime',-keyord=>'-dall'}]
				]
		}
	,'cmdbmv' =>{
		 -lbl		=>'CMDB - Records'
		,-cmt		=>'CMDB - Records of all elements and associations'
		,-lbl_ru	=>'КБД - Записи'
		,-cmt_ru	=>'КБД - Записи всех элементов и ассоциаций'
		,-hide		=>1
		,-table		=>'cmdbm'
		,-recQBF	=>'cmdbm'
		,-query		=>{-display	=>['record','status','vsubject']
				  ,-datainc	=>[qw(vorder vsubject)]
				  ,-order	=>'vorder,vsubject'
				  ,-keyord	=>'-aall'
					}
		,-limit		=>1024*4
		,-qhref		=>{-key=>['id'], -form=>'cmdbm', -cmd=>'recRead'}
		,-frmLsc	=>
				[{-val=>'alphabetically',-cmd=>{}}
				,['vorder',undef,{-order=>['vorder','vsubject'],-keyord=>'-aall'}]
				,['utime',undef, {-order=>'utime',-keyord=>'-dall'}]
				,['ctime',undef, {-order=>'ctime',-keyord=>'-dall'}]
				]
		}
	,'cmdbmva' =>{
		 -lbl		=>'CMDB - Association'
		,-cmt		=>'CMDB - Association records'
		,-lbl_ru	=>'КБД - Ассоциации'
		,-cmt_ru	=>'КБД - Записи ассоциаций'
		,-hide		=>1
		,-table		=>'cmdbm'
		,-recQBF	=>'cmdbm'
		,-query		=>{-display	=>['record','status','service','action','computer','interface','role','user','definition']
				  ,-datainc	=>[qw(vorder vsubject)]
				  ,-order	=>'vorder,vsubject'
				  ,-keyord	=>'-aall'
				  ,-where	=>"record IN('usage')"
					}
		,-limit		=>1024*4
		#,-qhref		=>{-key=>['id'], -form=>'cmdbm', -cmd=>'recRead'}
		,-frmLsc	=>undef
		}
	,'hdeskc'	=>{
		 -lbl		=>'Service Classifications'
		,-cmt		=>'Classifications of Service Desk records'
		,-lbl_ru	=>'ЦО - Классификации'
		,-cmt_ru	=>'Классификации записей Центра обслуживания запросов и инцидентов'
		,-table		=>'hdesk'
		,-recQBF	=>'hdesk'
		,-query		=>{-data	=>['vrecord','vcount']
				  ,-display	=>['vrecord','vcount']
				  ,-order	=>'vrecord'
				  ,-group	=>'vrecord'
				  ,-keyord	=>'-aall'
				#-data=>['application','vcount','vdefinition'],-display=>['application','vcount','vdefinition']
				#,-join =>'LEFT OUTER JOIN cgibus.cmdbm AS cmdbm ON (cmdbm.name=hdesk.application)'
				#,-where=>"cmdbm.idnv IS NULL OR (cmdbm.idnv ='')"
					}
		,-limit		=>1024*4
		,-qhref		=>{-key=>['object'], -form=>'hdesk', -cmd=>'recList'}
		,-frmLsc	=>
				[{-val=>'vrecord',-cmd=>{}}
				,{-val=>'vrd-u',-lbl=>'..news',-lbl_ru=>'..новости', -cmd=>{-order=>'utime',-keyord=>'-dall'}}
				,{-val=>'severity',-cmd=>{-data=>['severity','vcount'],-display=>['severity','vcount'],-group=>'severity',-order=>'severity',-keyord=>'-aall',-qhref=>{-key=>['severity'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'svr-u',-lbl=>'..news',-lbl_ru=>'..новости',-cmd=>{-data=>['severity','vcount'],-display=>['severity','vcount'],-group=>'severity',-order=>'utime',-keyord=>'-dall',-qhref=>{-key=>['severity'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'status',-cmd=>{-data=>['status','vcount'],-display=>['status','vcount'],-group=>'status',-order=>'status',-keyord=>'-aall',-qhref=>{-key=>['status'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'stt-u',-lbl=>'..news',-lbl_ru=>'..новости',-cmd=>{-data=>['status','vcount'],-display=>['status','vcount'],-group=>'status',-order=>'utime',-keyord=>'-dall',-qhref=>{-key=>['status'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'object',-cmd=>{-data=>['object','vcount'],-display=>['object','vcount'],-group=>'object',-order=>'object',-keyord=>'-aall',-qhref=>{-key=>['object'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'obj-u',-lbl=>'..news',-lbl_ru=>'..новости',-cmd=>{-data=>['object','vcount'],-display=>['object','vcount'],-group=>'object',-order=>'utime',-keyord=>'-dall',-qhref=>{-key=>['object'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'application',-cmd=>{-data=>['application','vcount'],-display=>['application','vcount'],-group=>'application',-order=>'application',-keyord=>'-aall',-qhref=>{-key=>['application'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'app-u',-lbl=>'..news',-lbl_ru=>'..новости',-cmd=>{-data=>['application','vcount'],-display=>['application','vcount'],-group=>'application',-order=>'utime',-keyord=>'-dall',-qhref=>{-key=>['application'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'location',-cmd=>{-data=>['location','vcount'],-display=>['location','vcount'],-group=>'location',-order=>'location',-keyord=>'-aall',-qhref=>{-key=>['location'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'loc-u',-lbl=>'..news',-lbl_ru=>'..новости',-cmd=>{-data=>['location','vcount'],-display=>['location','vcount'],-group=>'location',-order=>'utime',-keyord=>'-dall',-qhref=>{-key=>['location'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'cause',-cmd=>{-data=>['cause','vcount'],-display=>['cause','vcount'],-group=>'cause',-order=>'cause',-keyord=>'-aall',-qhref=>{-key=>['cause'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'cas-u',-lbl=>'..news',-lbl_ru=>'..новости',-cmd=>{-data=>['cause','vcount'],-display=>['cause','vcount'],-group=>'cause',-order=>'utime',-keyord=>'-dall',-qhref=>{-key=>['cause'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'process',-cmd=>{-data=>['process','vcount'],-display=>['process','vcount'],-group=>'process',-order=>'process',-keyord=>'-aall',-qhref=>{-key=>['process'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'prc-u',-lbl=>'..news',-lbl_ru=>'..новости',-cmd=>{-data=>['process','vcount'],-display=>['process','vcount'],-group=>'process',-order=>'utime',-keyord=>'-dall',-qhref=>{-key=>['process'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'puser',-cmd=>{-data=>['puser','vcount'],-display=>['puser','vcount'],-group=>'puser',-order=>'puser',-keyord=>'-aall',-qhref=>{-key=>['puser'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'pus-u',-lbl=>'..news',-lbl_ru=>'..новости',-cmd=>{-data=>['puser','vcount'],-display=>['puser','vcount'],-group=>'puser',-order=>'utime',-keyord=>'-dall',-qhref=>{-key=>['puser'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'prole',-cmd=>{-data=>['prole','vcount'],-display=>['prole','vcount'],-group=>'prole',-order=>'prole',-keyord=>'-aall',-qhref=>{-key=>['prole'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'prl-u',-lbl=>'..news',-lbl_ru=>'..новости',-cmd=>{-data=>['prole','vcount'],-display=>['prole','vcount'],-group=>'prole',-order=>'utime',-keyord=>'-dall',-qhref=>{-key=>['prole'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'auser',-cmd=>{-data=>['auser','vcount'],-display=>['auser','vcount'],-group=>'auser',-order=>'auser',-keyord=>'-aall',-qhref=>{-key=>['auser'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'aus-u',-lbl=>'..news',-lbl_ru=>'..новости',-cmd=>{-data=>['auser','vcount'],-display=>['auser','vcount'],-group=>'auser',-order=>'utime',-keyord=>'-dall',-qhref=>{-key=>['auser'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'arole',-cmd=>{-data=>['arole','vcount'],-display=>['arole','vcount'],-group=>'arole',-order=>'arole',-keyord=>'-aall',-qhref=>{-key=>['arole'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'arl-u',-lbl=>'..news',-lbl_ru=>'..новости',-cmd=>{-data=>['arole','vcount'],-display=>['arole','vcount'],-group=>'arole',-order=>'utime',-keyord=>'-dall',-qhref=>{-key=>['arole'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'mrole',-cmd=>{-data=>['mrole','vcount'],-display=>['mrole','vcount'],-group=>'mrole',-order=>'mrole',-keyord=>'-aall',-qhref=>{-key=>['mrole'], -form=>'hdesk', -cmd=>'recList'}}}
				,{-val=>'mrl-u',-lbl=>'..news',-lbl_ru=>'..новости',-cmd=>{-data=>['mrole','vcount'],-display=>['mrole','vcount'],-group=>'mrole',-order=>'utime',-keyord=>'-dall',-qhref=>{-key=>['mrole'], -form=>'hdesk', -cmd=>'recList'}}}
				]
		}
	,'hdeskg'=>{
		 -lbl		=>'Service Graph'
		,-cmt		=>'Service Desk State Matrix'
		,-lbl_ru	=>'ЦО - Граф'
		,-cmt_ru	=>'Сервисный граф по записям Центра обслуживания запросов и инцидентов'
		,-cgcCall	=>'cmdb-svcgrph.pl'
	}
	});

#$w->set(-index=>1);
#$w->set(-setup=>1);
$w->cgiRun();

##############################

sub a_hdesk_stbar {
 my ($s,$on,$om,$c,$mc) =@_;
 my $ah = $s->{-table}->{'hdesk'}->{-mdefld}
	&&$s->{-table}->{'hdesk'}->{-mdefld}->{'arole'}->{-inp}
	&&$s->lngslot($s->{-table}->{'hdesk'}->{-mdefld}->{'arole'}->{-inp},'-labels');
  # $ah =undef;
    $ah ={map {(lc($_) => $ah->{$_})} keys %$ah} if $ah;
 my $ac =$s->{-a_cmdbh_fsvrclr};
 my $acn=$s->{-table}->{'hdesk'}->{-mdefld}
	&&$s->{-table}->{'hdesk'}->{-mdefld}->{'severity'}->{-inp}
	&&$s->lngslot($s->{-table}->{'hdesk'}->{-mdefld}->{'severity'}->{-inp},'-labels');
 my $avs={};	# severities
 my $avg={};	# groups
 my $avp={};	# person current
 my $avc={};	# group current
 my $avu={};	# group current users
 my $qh =$s->recSel(-table=>'hdesk'
		,-data=>[qw(arole auser prole puser severity utime status record)]
		,-where=>"status IN('do','progress','rollback','delay','edit') OR (TO_DAYS(etime)=TO_DAYS(CURRENT_DATE()))"
		);
 my $vinit =sub{ # val init (record, key, store) -> store elem
		return($_[2]->{$_[1]}) if $_[2]->{$_[1]};
		my $v =$_[2]->{$_[1]} ={%{$_[0]}};
		foreach my $k (keys %$v) {$v->{$k} ='' if !defined($v->{$k})};
		$v->{severity} =4 if !defined($v->{severity}) ||($v->{severity} eq '');
		$v->{count} =0;
		$v
	};
 my $vset =sub { # val set (record, key, store) -> store elem
		my $q =$_[0];
		my $v =$_[2]->{$_[1]};
		$v->{severity} =$q->{severity}
			if defined($q->{severity}) && ($q->{severity} ne '')
			&& ($v->{severity} >$q->{severity});
		$v->{utime} =$q->{utime}
			if defined($q->{utime}) && ($q->{utime} ne '')
			&& ($v->{utime} lt $q->{utime});
		$v->{count}++
			if !$q->{status} || ($q->{status} =~/^(?:do|progress|rollback|delay|edit)$/);
	};
 while (my $qv =$qh->fetchrow_hashref()) {
	$qv->{severity} =3.5
		if (!defined($qv->{severity}) ||($qv->{severity} eq '4') ||($qv->{severity} eq ''))
		&& ($qv->{record} && ($qv->{record} eq 'unavlbl'));
	if (defined($qv->{severity}) && $ac->{$qv->{severity}}
	&& (!defined($qv->{record}) || ($qv->{record}!~/^(?:work|task)$/))) {
		&$vinit($qv, $qv->{severity}, $avs);
		&$vset($qv, $qv->{severity}, $avs);
	}
	if (1) {
		my $qn =lc($qv->{arole}||'');
		#  $qn ='' if !$ah->{$qn};
		&$vinit($qv, $qn, $avg);
		&$vset($qv, $qn, $avg)
	}
	if (grep {$qv->{$_} && (lc($qv->{$_}) eq lc($s->user))
			} qw (auser puser)) {
		&$vinit($qv, 'auser', $avp);
		&$vset($qv, 'auser', $avp);
	}
	if (grep {$qv->{$_} && (lc($qv->{$_}) eq lc($s->user))
			} qw (auser puser cuser uuser)) {
		&$vinit($qv, 'auser+', $avp);
		&$vset($qv, 'auser+', $avp);
	}
	if ($qv->{arole} && $s->{-pcmd}->{-quname}
	&& (lc($s->{-pcmd}->{-quname}) eq lc($qv->{arole})) ) {
		$avc->{act} =$avg->{lc($s->{-pcmd}->{-quname})};
		if ($qv->{auser}) {
			&$vinit($qv, lc($qv->{auser}), $avu);
			&$vset($qv, lc($qv->{auser}), $avu);
		}
		if ($qv->{arole} ne ($qv->{prole}||'')) {
			&$vinit($qv, 'svc', $avc);
			&$vset($qv, 'svc', $avc);
		}
		elsif ($qv->{arole} eq $qv->{prole}) {
			&$vinit($qv, 'self', $avc);
			&$vset($qv, 'self', $avc);
		}

	}
	elsif ($qv->{prole} && $s->{-pcmd}->{-quname}
	&& (lc($s->{-pcmd}->{-quname}) eq lc($qv->{prole})) ) {
			&$vinit($qv, 'req', $avc);
			&$vset($qv, 'req', $avc);
			$avc->{req}->{arole} =$s->{-pcmd}->{-quname};
	}
 }
 if ($ah) {
	foreach my $k (keys %$ah) {
		next if $avg->{lc($k)};
		&$vinit({}, lc($k), $avg);
		$avg->{$k}->{arole} =$k;
	}
 }
 if (!$s->uguest) {
	foreach my $k (qw(auser auser+)) {
		next if $avp->{$k};
		&$vinit({}, $k, $avp);
	}
 }
 if ($s->{-pcmd}->{-quname} && $s->{-pcmd}->{-qurole}
 && $avg->{lc($s->{-pcmd}->{-quname})} ){
	foreach my $k (qw(self svc req)) {
		next if $avc->{$k};
		&$vinit({}, $k, $avc);
		$avc->{$k}->{arole} =$s->{-pcmd}->{-quname};
	}
	$avc->{act} =$avg->{lc($s->{-pcmd}->{-quname})}
 }
#<div style="margin-bottom: 1ex; margin-top: 1ex;">
#<span style="border: 1px solid">
#<fieldset style="padding: 2"><legend>Group box</legend>#&nbsp;</fieldset>
 '<div style="margin-bottom: 0.4ex; margin-top: 0.5ex;">'
 .(!%$avs
  ? ''
  :(join('&nbsp;',
	map {	my $k =$_;
		# $s->logRec('***',$k,$avs->{$k});
		my $vl =$avs->{$k}->{count}||0;
		my $vt =($acn->{$k} ||$k);
		$s->htmlMQH(-html=>'&nbsp;' .$vl .'&nbsp;'
			,-title=>"$vl, $vt"
			,$k eq '3.5'
			? (-qkey=>{'record'=>'unavlbl'})
			: (-qkey=>{'severity'=>$k}
			  ,-qwhere=>"record NOT IN('work','task')")
			,-urm=>$avs->{$k}->{utime} ||''
			,-style=>'background-color: ' .$ac->{$k}||$ac->{''})
		} sort { $b <=> $a
			} keys %$avs)
 	.'&nbsp;&nbsp;&nbsp;'))
 .join('&nbsp;',
	map {	my $k =$_;
		# $s->logRec('*1*',$_,$avg->{$_});
		my $vl =$ah ? $ah->{$k} ||$s->udisp($avg->{$k}->{arole} ||$k) : $s->udisp($avg->{$k}->{arole} ||$k);
		my $vt =($ah && $ah->{$k} || $s->udisp($avg->{$k}->{arole} ||$k))
			.' <' .($avg->{$k}->{arole} ||$k) .'>';
		!$avg->{$k}->{arole}
		? ()
		: $s->htmlMQH(-label=>" $vl "
		, -title=>$vt 
			.($avg->{$k}->{count} ? ', ' .$avg->{$k}->{count} : '')
			.($acn && defined($avg->{$k}->{severity}) && ($avg->{$k}->{severity} ne '') 
				? ', ^' .($acn->{$avg->{$k}->{severity}} ||$avg->{$k}->{severity}) 
				: '')
		,-frmLso=>'actors', -quname=>$avg->{$k}->{arole}
		,-urm=>$avg->{$k}->{utime} ||''
		,-style=>'background-color: '
			.($ac->{$avg->{$k}->{severity}}||$ac->{''})
		)
		} sort {  !$ah		? $s->udisp($a||'') cmp $s->udisp($b||'')
			: !$ah->{$a} 	? 1 
			: !$ah->{$b} 	? -1 
			: (lc($ah->{$a||''}||'') cmp lc($ah->{$b||''}||''))
			} keys %$avg)
 .'</div>'
 .'<div style="margin-bottom: 0.4ex; margin-top: 0.5ex;">'
 .(!%$avp 
  ? ''
  :(join('',
	map {	my $k =$_;
		# $s->logRec('***',$k,$avp->{$k});
		my $vl =  $k eq 'auser'		? $s->udisp($s->user)
			: $k eq 'auser+'	? '+'
			: '?';
		my $vt =$k =~/^auser(\+*)/
			? $s->udisp($s->user) .' <' .$s->user .'>' .($1 ||'')
			: '?';
		$s->htmlMQH(-label=>$vl
		, -title=>$vt
			.($avp->{$k}->{count} ? ', ' .$avp->{$k}->{count} : '')
			.($acn && defined($avp->{$k}->{severity}) && ($avp->{$k}->{severity} ne '') 
				? ', ^' .($acn->{$avp->{$k}->{severity}} ||$avp->{$k}->{severity}) 
				: '')
		, $k eq 'auser' 
		? (-qwhere=>$s->dbi->quote($s->user) .' IN(hdesk.auser,hdesk.puser)')
		: $k eq 'auser+'
		? (-qwhere=>$s->dbi->quote($s->user) .' IN(hdesk.auser,hdesk.puser,hdesk.cuser,hdesk.uuser)')
		: (-frmLso=>'actor', -quname=>$avp->{$k}->{auser})
		,-urm=>$avp->{$k}->{utime} ||''
		,-style=>'background-color: '
			.$ac->{$avp->{$k}->{severity}}||$ac->{''}
		)} grep {$avp->{$_}} qw (auser auser+))
	.'&nbsp;&nbsp;&nbsp;'))
 .(!%$avc 
  ? ''
  :(join('&nbsp;',
	map {	my $k =$_;
		# $s->logRec('***',$k,$avc->{$k});
		my $vl =  $k eq 'self'		? $s->lng(0,'orole')
			: $k eq 'svc'		? $s->lng(0,'arole')
			: $k eq 'req'		? $s->lng(0,'users')
			: $k eq 'act'		? ($ah && $ah->{lc($avc->{$k}->{arole})} ||$s->udisp($avc->{$k}->{arole}))
			: '?';
		my $vt =($ah  && $ah->{lc($avc->{$k}->{arole})}
				||$s->udisp($avc->{$k}->{arole})) ." - $vl";
		$s->htmlMQH(-label=>length($vl) ==1 ? $vl : " $vl "
		, -title=>$vt 
			.($avc->{$k}->{count} ? ', ' .$avc->{$k}->{count} : '')
			.($acn && defined($avc->{$k}->{severity}) && ($avc->{$k}->{severity} ne '') 
				? ', ^' .($acn->{$avc->{$k}->{severity}} ||$avc->{$k}->{severity}) 
				: '')
		, $k eq 'self'
		? (-qwhere=>'arole=prole',-frmLso=>'actors', -quname=>$avc->{$k}->{arole})
		: $k eq 'svc'
		? (-qwhere=>'arole<>prole',-frmLso=>'actors', -quname=>$avc->{$k}->{arole})
		: $k eq 'req'
		? (-qwhere=>'(arole<>prole)',-frmLso=>'principals', -quname=>$avc->{$k}->{arole})
		: $k eq 'act'
		? (-frmLso=>'actors', -quname=>$avc->{$k}->{arole})
		: (-frmLso=>'actors', -quname=>$avc->{$k}->{arole})
		,-urm=>$avc->{$k}->{utime} ||''
		,-style=>'background-color: '
			.$ac->{$avc->{$k}->{severity}}||$ac->{''}
		)} grep {$avc->{$_}} qw (act svc self req))
 	.'&nbsp;&nbsp;&nbsp;'))
 . join('&nbsp;',
	map {	my $k =$_;
		# $s->logRec('***',$k,$avu->{$k});
		my $vl =$s->udisp($k);
		my $vt =$vl;
		   $vl =$vl =~/^([^\s]+)/ ? $1 : $vl;
		$s->htmlMQH(-label=>" $vl "
		, -title=>"$vt <$k>"
			.($avu->{$k}->{count} ? ', ' .$avu->{$k}->{count} : '')
			.($acn && defined($avu->{$k}->{severity}) && ($avu->{$k}->{severity} ne '') 
				? ', ^' .($acn->{$avu->{$k}->{severity}} ||$avu->{$k}->{severity}) 
				: '')
		,(-qkey=>{'auser'=>$avu->{$k}->{auser}}, -frmLso=>'actors', -quname=>$avu->{$k}->{arole})
		,-urm=>$avu->{$k}->{utime} ||''
		,-style=>'background-color: '
			.$ac->{$avu->{$k}->{severity}}||$ac->{''}
		)
		} sort { lc($s->udisp($a)) cmp lc($s->udisp($b))
			} keys %$avu)
 . '<br />'
 . '</div>'
 .$mc;
}


##############################
# Setup Script
##############################
#__END__
#
# Connect as root to mysql, once creating database and user:
#{$_->{-dbi} =undef; $_->{-dbiarg} =['DBI:mysql:mysql','root','password']; $_->dbi; <STDIN>}
#
# Reconnect as operational user, creating or upgrading tables:
#{$_->{-dbi} =undef; $_->{-dbiarg} =$_->{-dbiargpv}; $_->dbi; <STDIN>}
#
# Reindex database:
#{$s->recReindex(1)}
#
#
