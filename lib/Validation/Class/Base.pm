package Validation::Class::Base;

use strict;
use warnings;

# VERSION

use Exporter ();
use Carp 'confess';

our @ISA    = qw(Exporter);
our @EXPORT = qw(

    has
    hold

);

sub has {
    
    my ($attrs, $default) = @_;

    return unless $attrs;

    confess "Error creating accessor, default must be a coderef or constant"
        if ref $default && ref $default ne 'CODE';

    $attrs = [$attrs] unless ref $attrs eq 'ARRAY';

    for my $attr (@$attrs) {

        confess "Error creating accessor '$attr', name has invalid characters"
            unless $attr =~ /^[a-zA-Z_]\w*$/;
        
        my $code ;
        
        if (defined $default) {
            
            $code = sub {
                
                if (@_ == 1) {
                    return $_[0]->{$attr} if exists $_[0]->{$attr};
                    return $_[0]->{$attr} = ref $default eq 'CODE' ?
                        $default->($_[0]) : $default;
                }
                $_[0]->{$attr} = $_[1]; $_[0];
                
            };
            
        }
        
        else {
            
            $code = sub {
                
                return $_[0]->{$attr} if @_ == 1;
                $_[0]->{$attr} = $_[1]; $_[0];
                
            };
            
        }
        
        no strict 'refs';
        no warnings 'redefine';
        
        my $class = caller(0);
        
        *{"$class\::$attr"} = $code;
        
    }
    
}

sub hold {
    
    my ($attrs, $default) = @_;

    return unless $attrs;

    confess "Error creating accessor, default is required and must be a coderef"
        if ref $default ne 'CODE';

    $attrs = [$attrs] unless ref $attrs eq 'ARRAY';

    for my $attr (@$attrs) {

        confess "Error creating accessor '$attr', name has invalid characters"
            unless $attr =~ /^[a-zA-Z_]\w*$/;
        
        my $code ;
        
        $code = sub {
            
            if (@_ == 1) {
                return $_[0]->{$attr} if exists $_[0]->{$attr};
                return $_[0]->{$attr} = $default->($_[0]);
            }
            
            # values are read-only cannot be changed
            confess "Error attempting to modify the read-only attribute ($attr)";
            
        };
        
        no strict 'refs';
        no warnings 'redefine';
        
        my $class = caller(0);
        
        *{"$class\::$attr"} = $code;
        
    }
    
}

sub import {
    
    strict->import;
    warnings->import;
    
    __PACKAGE__->export_to_level(1, @_);
    
}

1;