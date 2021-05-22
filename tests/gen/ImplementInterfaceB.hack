/**
 * This file is generated. Do not modify it manually!
 *
 * To re-generate this file run vendor/bin/hacktest
 *
 *
 * @generated SignedSource<<b933cfad342d40fb6d6a3a0ec45fd17c>>
 */
namespace Slack\GraphQL\Test\Generated;
use namespace Slack\GraphQL;
use namespace Slack\GraphQL\Types;
use namespace HH\Lib\{C, Dict};

final class ImplementInterfaceB extends \Slack\GraphQL\Types\ObjectType {

  const NAME = 'ImplementInterfaceB';
  const type THackType = \ImplementInterfaceB;
  const keyset<string> FIELD_NAMES = keyset[
  ];
  const keyset<classname<Types\InterfaceType>> INTERFACES = keyset[
    IIntrospectionInterfaceA::class,
    IIntrospectionInterfaceB::class,
  ];

  public function getFieldDefinition(
    string $field_name,
  ): ?GraphQL\IResolvableFieldDefinition<this::THackType> {
    switch ($field_name) {
      default:
        return null;
    }
  }
}