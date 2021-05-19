namespace Slack\GraphQL\Codegen;

use namespace HH\Lib\{C, Str};
use type Facebook\HackCodegen\{HackBuilder, HackBuilderValues};

class MethodFieldBuilder implements IFieldBuilder {
    public function __construct(
        protected \Slack\GraphQL\Field $graphql_field,
        protected \ReflectionMethod $reflection_method,
    ) {}

    public function getIntrospectionField(HackBuilder $hb): string {
        $type = introspection_type($this->reflection_method->getReturnTypeText());

        $hb->addLine('\\Slack\\GraphQL\\Introspection\\V2\\__Field::for(')
            ->indent()
            ->addLinef('%s,', \var_export($this->graphql_field->getName(), true))
            ->addLinef('%s,', $type)
            ->unindent()
            ->addLine(')');

        return $hb->getCode();
    }

    public function addGetFieldDefinitionCase(HackBuilder $hb): void {
        $hb->addCase($this->graphql_field->getName(), HackBuilderValues::export());

        $hb->addLine('return new GraphQL\\FieldDefinition(')->indent();

        // Field name
        $name_literal = \var_export($this->graphql_field->getName(), true);
        $hb->addLinef('%s,', $name_literal);

        // Field return type
        $type_info = output_type(
            $this->reflection_method->getReturnTypeText(),
            $this->reflection_method->getAttributeClass(\Slack\GraphQL\KillsParentOnException::class) is nonnull,
        );
        $hb->addLinef('%s,', $type_info['type']);

        // Arguments
        $hb->addf(
            'async ($parent, $args, $vars) ==> %s%s%s(',
            $type_info['needs_await'] ? 'await ' : '',
            $this->getMethodCallPrefix(),
            $this->reflection_method->getName(),
        );
        $args = $this->getArgumentInvocationStrings();
        if (!C\is_empty($args)) {
            $hb->newLine()->indent();
            foreach ($args as $arg) {
                $hb->addLinef('%s,', $arg);
            }
            $hb->unindent();
        }
        $hb->addLine('),');

        // End of new GraphQL\FieldDefinition(
        $hb->unindent()->addLine(');');
        $hb->unindent();
    }

    protected function getMethodCallPrefix(): string {
        return Str\format('$parent%s', $this->reflection_method->isStatic() ? '::' : '->');
    }

    public function hasArguments(): bool {
        return $this->reflection_method->getNumberOfParameters() > 0;
    }

    protected function getArgumentInvocationStrings(): vec<string> {
        $invocations = vec[];
        foreach ($this->reflection_method->getParameters() as $index => $param) {
            $invocations[] = Str\format(
                '%s->coerce%sNamedNode(%s, $args, $vars%s)',
                input_type($param->getTypeText()),
                $param->isOptional() ? 'Optional' : '',
                \var_export($param->getName(), true),
                $param->isOptional() ? ', '.$param->getDefaultValueText() : '',
            );
        }
        return $invocations;
    }

    public function getName(): string {
        return $this->graphql_field->getName();
    }
}
