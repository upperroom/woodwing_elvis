 ###################################################
###
##  File: pmask.rb
##  Desc: Utility class to check permissions 'mask' for available permissions
#

module WoodWing
  class Elvis
    class Utilities

      # Utility class to check permissions 'mask' for available permissions.
      # The permissions mask consists of a string with one character for
      # every permission available in Elvis: VPUMERXCD

      class Pmask

        PERMISSIONS = {
          'V' => 'VIEW',
          'P' => 'VIEW_PREVIEW',
          'U' => 'USE_ORIGINAL',
          'M' => 'EDIT_METADATA',
          'E' => 'EDIT',
          'R' => 'RENAME',
          'X' => 'MOVE',
          'C' => 'CREATE',
          'D' => 'DELETE',
        }

        def initialize(pmask='')
          @pmask = pmask
        end

        def verbose
          v=[]
          @pmask.each_char{|c| v<<PERMISSIONS[c]}
          return v.join(', ')
        end

        define_method('can_view?')          { @pmask.include? 'V' }
        define_method('can_view_preview?')  { @pmask.include? 'P' }
        define_method('can_use_original?')  { @pmask.include? 'U' }
        define_method('can_edit_metadata?') { @pmask.include? 'M' }
        define_method('can_edit?')          { @pmask.include? 'E' }
        define_method('can_rename?')        { @pmask.include? 'R' }
        define_method('can_move?')          { @pmask.include? 'X' }
        define_method('can_create?')        { @pmask.include? 'C' }
        define_method('can_delete?')        { @pmask.include? 'D' }

      end # class Pmask
    end # class Utilities
  end # class Elvis
end # module WoodWing
