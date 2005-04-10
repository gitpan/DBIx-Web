#!perl -w
#http://localhost/cgi-bin/web.cgi
BEGIN {
# push @INC, $1 .'sitel/lib' if !(grep /sitel/i, @INC) && ($INC[0] =~/(.+?[\\\/])lib$/i)
}
use DBIx::Web;
my $w =DBIx::Web->new(
	  -serial	=>2
	 ,-debug	=>2
	 ,-dbiarg	=>undef
	#,-path		=>"$ENV{DOCUMENT_ROOT}/dbix-web"
	#,-url		=>'/cgi-bus'
	 ,-urf		=>'-path'
	#,-racAdmRdr	=>''
	#,-racAdmWtr	=>''
	);
my ($r, $c);
$w->set(-table=>{
	'note'=>{
		 -lbl		=>'Notes'
		,-cmt		=>'Notes'
		,-field		=>[
			 {-fld=>'id'
				,-flg=>'kwq'
				,-lblhtml=>$w->tfoShow('id_',['idrm','idpr'])
				}, ''
			,{-fld=>$w->tn('-rvcActPtr')
				,-flg=>'q'
				,-hidel=>$w->tfoHide('id_')
				}
			,{-fld=>'idrm'
				,-flg=>'euq'
				,-hidel=>$w->tfoHide('id_')
				}, ''
			,{-fld=>'idpr'
				,-flg=>'euq'
				,-hidel=>$w->tfoHide('id_')
				}
			,{-fld=>$w->tn('-rvcInsWhen')
				,-flg=>'q'
				}, ''
			,{-fld=>$w->tn('-rvcInsBy')
				,-flg=>'q'
				}
			,{-fld=>$w->tn('-rvcUpdWhen')
				,-flg=>'wql'
				}, ''
			,{-fld=>$w->tn('-rvcUpdBy')
				,-edit=>0
				,-flg=>'wql'
				}
			,{-fld=>'authors'
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			,-ddlbtgt=>[[undef,undef,','],['readers',undef,',']]
			 	}, ''
			,{-fld=>'readers'
			,-flg=>'euq'
			,-ddlb=>sub{$_[0]->uglist({})}
			,-ddlbtgt=>[[undef,undef,','],['authors',undef,',']]
				 }
			,{-fld=>$w->tn('-rvcState')
			,-inp=>{-values=>$w->tn('-rvcAllState')}
			,-flg=>'euql'
				}
			,{-fld=>'subject'
			,-flg=>'euql'
			,-colspan=>4
			,-inp=>{-asize=>60}
			# ,-ddlb=>[[1,'one'],2,3,'qw']	# test
				 }
			,"</table>"
			,{-fld=>'comment'
			,-flg=>'eu'
			,-lblhtml=>'<b>$_</b><br />'
			,-inp=>{-htmlopt=>1, -hrefs=>1, -arows=>5, -cols=>70}
				 }
			,$w->tfsAll()
		]
		,$w->ttoRVC()
		,-racReader	=>[qw(readers)]
		,-racWriter	=>[$w->tn('-rvcUpdBy'), $w->tn('-rvcInsBy'), 'authors']
		,-ridRef	=>[qw(idrm idpr comment)]
		,-rfa		=>1
		,-query		=>{-order=>'-dall'}
		,-dbd		=>'dbm'
	}
	,$w->ttsAll()
	});

$w->set(-form=>{
	 'default'	=>{-subst=>'index'}
	,$w->tvdIndex()
	,$w->tvdFTQuery()
	,'notehier'	=>{
		 -lbl		=>'Notes hierarchy'
		,-cmt		=>'Notes hierarchy'
		,-table		=>'note'
		,-query		=>{-order=>'-dall'} # -key=>{'idrm'=>undef}
		,-qfilter	=>sub{!$_[4]->{'idrm'}}
		}
	});
$w->set(-index=>1);
$w->set(-setup=>1);
$w->cgiRun();

##############################
# Setup Script
##############################
__END__
#
# Connect as root to mysql, once creating database and user:
#{$_->{-dbi} =undef; $_->{-dbiarg} =['DBI:mysql:mysql','root','password']; $_->dbi; <STDIN>}
#
# Reconnect as operational user, creating or upgrading tables:
#{$_->{-dbi} =undef; $_->{-dbiarg} =$_->{-dbiargpv}; $_->dbi; <STDIN>}
#
# Reindex database:
{$s->recReindex(1)}
#
#
