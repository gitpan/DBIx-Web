#!perl -w
#http://localhost/cgi-bin/web.cgi
BEGIN {
 push @INC, $1 .'sitel/lib' if !(grep /sitel/i, @INC) && ($INC[0] =~/(.+?[\\\/])lib$/i)
}
use DBIx::Web;
my $w =DBIx::Web->new(-serial=>2, -debug=>2);
my ($r, $c);
$w->set(-table=>{
	'note'=>{
		 -lbl		=>'Notes'
		,-cmt		=>'Notes'
		,-field		=>[
			 {-fld=>'id'
				,-flg=>'kwq'
				,-lblhtml=>$w->ddfShow('id_',['idrm','idpr'])
				}, ''
			,{-fld=>$w->ns('-rvcActPtr')
				,-flg=>'q'
				,-hidel=>$w->ddfHide('id_')
				}
			,{-fld=>'idrm'
				,-flg=>'euq'
				,-hidel=>$w->ddfHide('id_')
				}, ''
			,{-fld=>'idpr'
				,-flg=>'euq'
				,-hidel=>$w->ddfHide('id_')
				}
			,{-fld=>$w->ns('-rvcInsWhen')
				,-flg=>'q'
				}, ''
			,{-fld=>$w->ns('-rvcInsBy')
				,-flg=>'q'
				}
			,{-fld=>$w->ns('-rvcUpdWhen')
				,-flg=>'wql'
				}, ''
			,{-fld=>$w->ns('-rvcUpdBy')
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
				 }
			,{-fld=>$w->ns('-rvcState')
			,-inp=>{-values=>$w->ns('-rvcAllState')}
			,-flg=>'euql'
				}, ''
			,{-fld=>'subject'
			,-flg=>'euql'
			,-inp=>{-asize=>60}
			,-ddlb=>[[1,'one'],2,3,'qw']
				 }
			,"\f"
			,{-fld=>'comment'
			,-flg=>'eu'
			,-lblhtml=>'<b>$_</b><br />'
			,-inp=>{-htmlopt=>1, -hrefs=>1, -arows=>5, -cols=>70}
				 }
			,$w->ddfAll()
		]
		,$w->ddoRVC()
		,-racReader	=>[qw(readers)]
		,-racWriter	=>[$w->ns('-rvcUpdBy'), $w->ns('-rvcInsBy'), 'authors']
		,-ridRef	=>[qw(idrm idpr comment)]
		,-rfa		=>1
		,-query		=>{-order=>'-dall'}
		,-dbd		=>'dbm'
	}
	,$w->ddvAll()
	});

$w->set(-form=>{
	  'default'=>{-subst=>'note'}
	 ,'notehier'=>{
		 -lbl		=>'Notes hierarchy'
		,-cmt		=>'Notes hierarchy'
		,-table		=>'note'
		,-query		=>{-order=>'-dall'} # -key=>{'idrm'=>''}
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
