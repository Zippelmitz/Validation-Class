# ABSTRACT: Generic Container Class for Various Collections

package Validation::Class::Collection;

use strict;
use warnings;

# VERSION

use Carp 'confess';

=head1 SYNOPSIS

    use Validation::Class::Collection;
    
    my $foos = Validation::Class::Collection->new;
    
    $foos->add(foo => Foo->new);
    
    print $foos->count; # 1 object

=head1 DESCRIPTION

Validation::Class::Collection provides an all-purpose container for objects.
This class is primarily used as a base class for collection management classes.

=cut

=method new

    my $self = Validation::Class::Collection->new;

=cut

sub new {
    
    my $class = shift;
    
    my %arguments = @_ % 2 ? %{$_[0]} : @_;
    
    my $self = bless {}, $class;
    
    while (my($name, $value) = each(%arguments)) {
        
        $self->add($name => $value);
        
    }
    
    return $self;
    
}

=method add

    $self = $self->add(foo => Foo->new);
    
    $self->add(foo => Foo->new, bar => Bar->new);

=cut

sub add {
    
    my $self = shift;
    
    my %arguments = @_ % 2 ? %{$_[0]} : @_;
    
    while (my($key, $object) = each %arguments) {
    
        $self->{$key} = $object;
    
    }
    
    return $self;
    
}

=method clear

    $self = $self->clear;

=cut

sub clear {
    
    my ($self) = @_;
    
    delete $self->{$_} for keys %{$self} ;
    
    return $self;
    
}

=method count

    my $count = $self->count; 

=cut

sub count {
    
    return scalar(keys %{$_[0]});
    
}

=method each

    $self = $self->each(sub{
        
        my ($name, $object) = @_;
        ...
        
    });

=cut

sub each {
    
    my ($self, $transformer) = @_;
    
    $transformer ||= sub {@_} ;
    
    while (my @kv = each(%{$self})) {
        
        $transformer->(@kv);
        
    }
    
    return $self;
    
}

=method find

    my $matches = $self->find(qr/update_/); # hashref

=cut

sub find {
    
    my ($self, $pattern) = @_;
    
    return undef unless "REGEXP" eq uc ref $pattern;
    
    my %matches = ();
    
    $matches{$_} = $self->{$_}
        for grep { $_ =~ $pattern } keys %{$self};
    
    return { %matches };
    
}

=method hash

    my $hash = $self->hash; 

=cut

sub hash {
    
    return {%{$_[0]}};
    
}

=method keys

    my @keys = $self->keys;

=cut

sub keys {
    
    return (keys %{$_[0]});
    
}

=method list

    my @objects = $self->list;

=cut

sub list {
    
    return (values %{$_[0]});
    
}

=method delete

    my @values = $self->delete(@names);

=cut

sub delete {
    
    my ($self, @names) = @_;
    
    my @values = map {
    
        delete $self->{$_}
    
    }  @names;
    
    return (@values);
    
}

=method values

    my @objects = $self->values;

=cut

sub values {
    
    goto &list;
    
}

1;